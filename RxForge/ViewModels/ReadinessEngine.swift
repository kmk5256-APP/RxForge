import Foundation

// RxForge's signature calculation. Deliberately a pure function of evidence in, numbers
// out — no SwiftData, no SwiftUI — so it can be reasoned about and tested on its own.
//
// IMPORTANT (see CLAUDE.md): the Readiness Score is a study-progress composite. It is
// not a predicted NAPLEX score, a percentile, or a probability of passing, and no
// surface in the app may present it as one.

/// Per-domain evidence, summarised from `AnswerRecord`s.
struct DomainEvidence {
    let domain: Domain
    let attempts: Int
    let correct: Int
    let lastAnswered: Date?

    var rawAccuracy: Double {
        attempts > 0 ? Double(correct) / Double(attempts) : 0
    }
}

/// What the engine concluded about one domain.
struct DomainReadiness: Identifiable {
    let domain: Domain
    /// Evidence-shrunk accuracy, 0...1. With few attempts this sits near the prior
    /// rather than at the raw percentage — 2/2 correct is not 100% mastery.
    let mastery: Double
    /// How much of the evidence target for this domain has been met, 0...1.
    let coverage: Double
    let attempts: Int
    let correct: Int
    let rawAccuracy: Double
    /// Blueprint weight × room to improve × evidence gap. Higher means studying this
    /// moves the overall score more than studying anything else.
    let leverage: Double

    var id: String { domain.rawValue }

    /// True when there is too little evidence to say anything honest about this domain.
    var isUnderEvidenced: Bool { attempts < 5 }
}

/// Which input is holding the score down the most.
enum LimitingFactor: String {
    case mastery = "Accuracy"
    case coverage = "Volume"
    case consistency = "Consistency"

    var guidance: String {
        switch self {
        case .mastery:
            return "Your score is limited by accuracy. Work the explanations on missed questions before adding volume."
        case .coverage:
            return "Your score is limited by how much you've answered. There isn't enough evidence yet to score you higher."
        case .consistency:
            return "Your score is limited by how often you study. Short daily sessions move this more than one long one."
        }
    }
}

/// How much evidence sits behind the score. Governs the width of the confidence band.
enum EvidenceLevel: String {
    case minimal = "Building evidence"
    case moderate = "Narrowing"
    case strong = "Well-evidenced"

    var explanation: String {
        switch self {
        case .minimal:
            return "Under 50 questions answered. Treat the score as a rough first read."
        case .moderate:
            return "Enough answered to see a trend, not enough to be precise."
        case .strong:
            return "Enough questions answered for the score to be reasonably stable."
        }
    }
}

/// The complete result of a readiness calculation.
struct ReadinessBreakdown {
    let score: Int                  // 0...100
    let mastery: Double             // 0...1, blueprint-weighted, shrunk
    let coverage: Double            // 0...1, evidence volume against target
    let consistency: Double         // 0...1, study regularity
    let confidenceHalfWidth: Int    // ± points
    let evidenceLevel: EvidenceLevel
    let limitingFactor: LimitingFactor
    let domains: [DomainReadiness]
    let totalAttempts: Int

    /// Lowest plausible value of the score, clamped to 0.
    var confidenceLow: Int { max(0, score - confidenceHalfWidth) }
    /// Highest plausible value of the score, clamped to 100.
    var confidenceHigh: Int { min(100, score + confidenceHalfWidth) }

    /// The single domain worth studying next, or nil when there is no evidence at all.
    var highestLeverageDomain: DomainReadiness? {
        domains.max { $0.leverage < $1.leverage }
    }

    /// Qualitative band. Phrased as study progress, never as a pass prediction.
    var band: String {
        switch score {
        case ..<40: return "Early"
        case ..<60: return "Building"
        case ..<75: return "Consolidating"
        case ..<88: return "Strong"
        default:    return "Well prepared"
        }
    }

    static let empty = ReadinessBreakdown(
        score: 0, mastery: 0, coverage: 0, consistency: 0,
        confidenceHalfWidth: 0, evidenceLevel: .minimal, limitingFactor: .coverage,
        domains: Domain.allCases.map {
            DomainReadiness(domain: $0, mastery: 0, coverage: 0, attempts: 0,
                            correct: 0, rawAccuracy: 0, leverage: $0.examWeight)
        },
        totalAttempts: 0
    )
}

enum ReadinessEngine {

    // MARK: - Tuning constants
    //
    // Grouped here so the model is legible and adjustable in one place.

    /// Weight of blueprint-weighted accuracy in the composite.
    static let masteryWeight = 0.70
    /// Weight of evidence volume.
    static let coverageWeight = 0.20
    /// Weight of study regularity.
    static let consistencyWeight = 0.10

    /// Pseudo-observations pulling a thin domain's accuracy toward `priorAccuracy`.
    /// This is what stops "2 for 2" reading as total mastery.
    static let priorStrength = 8.0
    static let priorAccuracy = 0.50

    /// Questions that constitute full evidence across all domains, split by blueprint
    /// weight. Domain 3 (40%) therefore needs the most before it stops limiting the score.
    static let fullEvidenceTotal = 250.0
    static let minimumDomainTarget = 12

    /// Trailing window for the consistency term.
    static let consistencyWindowDays = 14
    /// Days studied within that window that count as full consistency.
    static let consistencyTargetDays = 10.0
    /// Beyond this many days idle, consistency is halved — a strong week last month is
    /// not readiness today.
    static let stalenessThresholdDays = 7

    // MARK: - Entry point

    /// Compute the breakdown from raw evidence.
    ///
    /// - Parameters:
    ///   - evidence: per-domain totals. Domains absent from the array are treated as zero.
    ///   - studyDays: distinct calendar days on which the learner answered anything.
    ///   - now: injected for testability.
    static func evaluate(evidence: [DomainEvidence],
                         studyDays: Set<Date>,
                         now: Date = Date(),
                         calendar: Calendar = .current) -> ReadinessBreakdown {

        let byDomain = Dictionary(uniqueKeysWithValues: evidence.map { ($0.domain, $0) })
        let totalAttempts = evidence.reduce(0) { $0 + $1.attempts }

        guard totalAttempts > 0 else { return .empty }

        // --- Per-domain mastery and coverage ---
        var domainResults: [DomainReadiness] = []
        var weightedMastery = 0.0
        var weightedCoverage = 0.0

        for domain in Domain.allCases {
            let e = byDomain[domain] ?? DomainEvidence(domain: domain, attempts: 0,
                                                       correct: 0, lastAnswered: nil)

            // Bayesian shrinkage toward the prior, proportional to how thin the evidence is.
            let mastery = (Double(e.correct) + priorStrength * priorAccuracy)
                        / (Double(e.attempts) + priorStrength)

            let target = evidenceTarget(for: domain)
            let coverage = min(1.0, Double(e.attempts) / Double(target))

            // Studying a domain pays off in proportion to its exam weight, how much room
            // is left in it, and how thin its evidence is.
            let leverage = domain.examWeight * (1 - mastery) * (0.5 + 0.5 * (1 - coverage))

            domainResults.append(DomainReadiness(domain: domain,
                                                 mastery: mastery,
                                                 coverage: coverage,
                                                 attempts: e.attempts,
                                                 correct: e.correct,
                                                 rawAccuracy: e.rawAccuracy,
                                                 leverage: leverage))

            weightedMastery += domain.examWeight * mastery
            weightedCoverage += domain.examWeight * coverage
        }

        // --- Consistency ---
        let consistency = consistencyScore(studyDays: studyDays, now: now, calendar: calendar)

        // --- Composite ---
        let composite = masteryWeight * weightedMastery
                      + coverageWeight * weightedCoverage
                      + consistencyWeight * consistency
        let score = Int((composite * 100).rounded())

        // --- Confidence band ---
        // Standard error of the blueprint-weighted mastery, treating each domain as a
        // binomial with its shrunk rate and effective sample size.
        var variance = 0.0
        for r in domainResults {
            let n = Double(r.attempts) + priorStrength
            variance += pow(r.domain.examWeight, 2) * r.mastery * (1 - r.mastery) / n
        }
        let halfWidth = Int((1.96 * sqrt(variance) * 100).rounded())
            .clamped(to: 2...35)

        let evidenceLevel: EvidenceLevel = {
            switch totalAttempts {
            case ..<50: return .minimal
            case ..<200: return .moderate
            default: return .strong
            }
        }()

        // --- What is holding the score back ---
        let gaps: [(LimitingFactor, Double)] = [
            (.mastery, masteryWeight * (1 - weightedMastery)),
            (.coverage, coverageWeight * (1 - weightedCoverage)),
            (.consistency, consistencyWeight * (1 - consistency)),
        ]
        let limiting = gaps.max { $0.1 < $1.1 }?.0 ?? .coverage

        return ReadinessBreakdown(score: score,
                                  mastery: weightedMastery,
                                  coverage: weightedCoverage,
                                  consistency: consistency,
                                  confidenceHalfWidth: halfWidth,
                                  evidenceLevel: evidenceLevel,
                                  limitingFactor: limiting,
                                  domains: domainResults,
                                  totalAttempts: totalAttempts)
    }

    /// Questions in a domain that constitute full evidence for it.
    static func evidenceTarget(for domain: Domain) -> Int {
        max(minimumDomainTarget, Int((fullEvidenceTotal * domain.examWeight).rounded()))
    }

    /// Regularity over the trailing window, decayed if the learner has gone quiet.
    static func consistencyScore(studyDays: Set<Date>,
                                 now: Date,
                                 calendar: Calendar = .current) -> Double {
        guard let windowStart = calendar.date(byAdding: .day,
                                              value: -consistencyWindowDays,
                                              to: calendar.startOfDay(for: now)) else { return 0 }

        let recentDays = studyDays.filter { $0 >= windowStart }
        guard !recentDays.isEmpty else { return 0 }

        var score = min(1.0, Double(recentDays.count) / consistencyTargetDays)

        if let mostRecent = recentDays.max() {
            let idle = calendar.dateComponents([.day],
                                               from: mostRecent,
                                               to: calendar.startOfDay(for: now)).day ?? 0
            if idle > stalenessThresholdDays { score *= 0.5 }
        }
        return score
    }

    /// The mastery level `headroom` measures against — "solid command of the domain"
    /// rather than perfection, which is neither achievable nor a useful target.
    static let headroomTarget = 0.85

    /// Points the overall score would gain if this domain reached `headroomTarget`
    /// mastery with its evidence target met. Powers the "what would move your score
    /// most" panel and the Home routing card.
    ///
    /// This is a counterfactual about *where the room is*, not a prediction. Projecting
    /// "answer N more at your current rate" is nearly useless here — by construction it
    /// leaves mastery unchanged and moves only the 20% volume term, so every domain
    /// returns roughly the same tiny number and the ranking carries no information.
    static func headroom(from breakdown: ReadinessBreakdown,
                         forDomain domain: Domain) -> Int {
        guard let current = breakdown.domains.first(where: { $0.domain == domain }) else { return 0 }

        let masteryDelta = domain.examWeight * max(0, headroomTarget - current.mastery)
        let coverageDelta = domain.examWeight * max(0, 1 - current.coverage)

        let delta = masteryWeight * masteryDelta + coverageWeight * coverageDelta
        return max(0, Int((delta * 100).rounded()))
    }
}

private extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
