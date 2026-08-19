import Foundation

/// The practice bank, plus the sampling that assembles a session.
///
/// Content lives in the `Bank+<Domain>.swift` files; this type only aggregates and
/// samples. Question IDs are stable across releases — answer history is keyed on them,
/// so an ID must never be reused for different content (see `Question.id`).
enum QuestionBank {

    static let all: [Question] =
        foundational + medicationUse + assessmentPlanning + professionalPractice + managementLeadership

    static func questions(for domain: Domain) -> [Question] {
        all.filter { $0.domain == domain }
    }

    static func question(id: String) -> Question? {
        all.first { $0.id == id }
    }

    static func count(for domain: Domain) -> Int {
        questions(for: domain).count
    }

    /// Number of distinct topics in a domain that the bank actually covers.
    static func coveredTopics(for domain: Domain) -> Set<String> {
        Set(questions(for: domain).map(\.topic))
    }

    // MARK: - Sampling

    /// Build the question list for a session.
    ///
    /// - Parameters:
    ///   - mode: what kind of session to assemble.
    ///   - missedIDs: questions whose most recent attempt was wrong.
    ///   - seenIDs: every question already answered at least once. Unseen questions are
    ///     preferred so learners don't loop over the same handful.
    static func sample(for mode: SessionMode,
                       missedIDs: Set<String> = [],
                       seenIDs: Set<String> = []) -> [Question] {
        switch mode {
        case .quickQuiz:
            return blueprintWeightedSample(count: mode.questionCount, seenIDs: seenIDs)

        case .timedBlock(let n):
            return blueprintWeightedSample(count: n, seenIDs: seenIDs)

        case .domainFocus(let domain):
            let pool = questions(for: domain)
            return preferUnseen(pool, count: min(mode.questionCount, pool.count), seenIDs: seenIDs)

        case .missedReview:
            let pool = all.filter { missedIDs.contains($0.id) }
            return Array(pool.shuffled().prefix(mode.questionCount))
        }
    }

    /// Draw `count` questions with each domain represented in proportion to its exam
    /// weight — the sampling that makes a Quick Quiz feel like a miniature exam.
    ///
    /// Uses largest-remainder allocation so the parts always sum to `count`, then tops
    /// up from the global pool if a domain is too thin to fill its share.
    static func blueprintWeightedSample(count: Int, seenIDs: Set<String> = []) -> [Question] {
        guard count > 0, !all.isEmpty else { return [] }

        // Ideal (fractional) allocation per domain.
        let ideals = Domain.allCases.map { (domain: $0, ideal: Double(count) * $0.examWeight) }
        var allocation = Dictionary(uniqueKeysWithValues: ideals.map { ($0.domain, Int($0.ideal)) })

        // Distribute the remainder to the largest fractional parts.
        var shortfall = count - allocation.values.reduce(0, +)
        let byRemainder = ideals
            .map { ($0.domain, $0.ideal - Double(Int($0.ideal))) }
            .sorted { $0.1 > $1.1 }
        var i = 0
        while shortfall > 0 && !byRemainder.isEmpty {
            allocation[byRemainder[i % byRemainder.count].0, default: 0] += 1
            shortfall -= 1
            i += 1
        }

        var picked: [Question] = []
        for domain in Domain.allCases {
            let want = allocation[domain] ?? 0
            guard want > 0 else { continue }
            let pool = questions(for: domain)
            picked += preferUnseen(pool, count: min(want, pool.count), seenIDs: seenIDs)
        }

        // A thin domain can leave the block short; fill from whatever is left.
        if picked.count < count {
            let chosen = Set(picked.map(\.id))
            let rest = all.filter { !chosen.contains($0.id) }
            picked += preferUnseen(rest, count: count - picked.count, seenIDs: seenIDs)
        }

        return picked.shuffled()
    }

    /// Take `count` from `pool`, exhausting unseen questions before repeating seen ones.
    private static func preferUnseen(_ pool: [Question],
                                     count: Int,
                                     seenIDs: Set<String>) -> [Question] {
        guard count > 0 else { return [] }
        let unseen = pool.filter { !seenIDs.contains($0.id) }.shuffled()
        if unseen.count >= count { return Array(unseen.prefix(count)) }

        let seen = pool.filter { seenIDs.contains($0.id) }.shuffled()
        return unseen + seen.prefix(count - unseen.count)
    }

    // MARK: - Integrity
    //
    // Cheap invariants worth asserting in DEBUG rather than discovering in review:
    // duplicate IDs would corrupt answer history, and an out-of-range key would crash.

    #if DEBUG
    static func validate() -> [String] {
        var problems: [String] = []

        let ids = all.map(\.id)
        let duplicates = Dictionary(grouping: ids, by: { $0 }).filter { $1.count > 1 }.keys
        if !duplicates.isEmpty {
            problems.append("Duplicate question IDs: \(duplicates.sorted().joined(separator: ", "))")
        }

        for q in all {
            if q.choices.count < 2 {
                problems.append("\(q.id): fewer than two choices")
            }
            if !q.choices.indices.contains(q.correctIndex) {
                problems.append("\(q.id): correctIndex \(q.correctIndex) out of range")
            }
            if Set(q.choices).count != q.choices.count {
                problems.append("\(q.id): duplicate choice text")
            }
            if !q.domain.topics.contains(q.topic) {
                problems.append("\(q.id): topic '\(q.topic)' is not a topic of \(q.domain.shortName)")
            }
            if q.explanation.trimmingCharacters(in: .whitespaces).isEmpty {
                problems.append("\(q.id): empty explanation")
            }
        }

        if !Domain.weightsSumToOne {
            problems.append("Domain exam weights do not sum to 1.0")
        }

        return problems
    }
    #endif
}
