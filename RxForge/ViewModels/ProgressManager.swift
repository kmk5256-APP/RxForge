import Foundation
import SwiftData
import Observation

/// Owns the SwiftData context and turns stored answers into everything the UI shows.
///
/// Deliberately the only type that touches `ModelContext`. Views read derived values
/// (`readiness`, `streak`, `totalStudyTime`) and call `record` / `completeSession`;
/// they never query the store themselves.
@Observable
final class ProgressManager {

    private(set) var readiness: ReadinessBreakdown = .empty
    private(set) var totalAnswered = 0
    private(set) var totalCorrect = 0
    private(set) var totalStudyTime: TimeInterval = 0
    private(set) var streak = 0
    private(set) var longestStreak = 0
    private(set) var recentSessions: [StudySession] = []
    /// `Question.id`s the learner has answered incorrectly and not since got right.
    private(set) var missedQuestionIDs: Set<String> = []
    /// Answered at least once, in any session. Used to prefer unseen questions.
    private(set) var seenQuestionIDs: Set<String> = []

    var examDate: Date? {
        get { profile?.examDate }
        set {
            profile?.examDate = newValue
            save()
        }
    }

    var dailyGoal: Int {
        get { profile?.dailyGoal ?? 20 }
        set {
            profile?.dailyGoal = max(5, newValue)
            save()
        }
    }

    @ObservationIgnored private var context: ModelContext?
    @ObservationIgnored private var profile: UserProgress?

    // MARK: - Lifecycle

    /// Called once from `RxForgeApp`. Safe to call again; it will no-op.
    func configure(with context: ModelContext) {
        guard self.context == nil else { return }
        self.context = context
        loadProfile()
        refresh()
    }

    private func loadProfile() {
        guard let context else { return }
        let existing = (try? context.fetch(FetchDescriptor<UserProgress>())) ?? []
        if let first = existing.first {
            profile = first
        } else {
            let created = UserProgress()
            context.insert(created)
            profile = created
            save()
        }
    }

    // MARK: - Recording

    /// Persist one answered question and update every derived value.
    func record(question: Question,
                wasCorrect: Bool,
                secondsSpent: Double,
                mode: SessionMode,
                at date: Date = Date()) {
        guard let context else {
            // Dropping evidence silently is the worst failure this class can have —
            // the score would quietly stop reflecting reality. Surface it in DEBUG.
            assertionFailure("ProgressManager.record called before configure(with:); answer discarded.")
            return
        }

        context.insert(AnswerRecord(questionID: question.id,
                                    domain: question.domain,
                                    topic: question.topic,
                                    wasCorrect: wasCorrect,
                                    answeredAt: date,
                                    secondsSpent: secondsSpent,
                                    sessionModeID: mode.id))

        profile?.registerStudy(on: date)
        save()
        refresh()
    }

    /// Persist a finished session. Call after the last `record` of that session.
    func completeSession(mode: SessionMode,
                         startedAt: Date,
                         endedAt: Date = Date(),
                         answered: Int,
                         correct: Int) {
        guard let context, answered > 0 else { return }
        context.insert(StudySession(startedAt: startedAt,
                                    endedAt: endedAt,
                                    modeID: mode.id,
                                    modeTitle: mode.title,
                                    questionsAnswered: answered,
                                    questionsCorrect: correct))
        save()
        refresh()
    }

    // MARK: - Derived state

    /// Recompute everything from the store. Cheap enough at this data scale to do after
    /// each answer, and it keeps the UI honest — there is no incrementally-updated copy
    /// that can drift from what is persisted.
    func refresh() {
        guard let context else { return }

        let answers = (try? context.fetch(FetchDescriptor<AnswerRecord>())) ?? []

        totalAnswered = answers.count
        totalCorrect = answers.filter(\.wasCorrect).count

        // Per-domain evidence.
        var evidence: [Domain: (attempts: Int, correct: Int, last: Date?)] = [:]
        for a in answers {
            var bucket = evidence[a.domain] ?? (0, 0, nil)
            bucket.attempts += 1
            if a.wasCorrect { bucket.correct += 1 }
            if let existing = bucket.last {
                bucket.last = max(existing, a.answeredAt)
            } else {
                bucket.last = a.answeredAt
            }
            evidence[a.domain] = bucket
        }

        let domainEvidence = Domain.allCases.map { domain -> DomainEvidence in
            let b = evidence[domain] ?? (0, 0, nil)
            return DomainEvidence(domain: domain, attempts: b.attempts,
                                  correct: b.correct, lastAnswered: b.last)
        }

        let calendar = Calendar.current
        let studyDays = Set(answers.map { calendar.startOfDay(for: $0.answeredAt) })

        readiness = ReadinessEngine.evaluate(evidence: domainEvidence, studyDays: studyDays)

        // A question counts as "missed" only if its most recent attempt was wrong —
        // getting it right later should retire it from review.
        var latestOutcome: [String: (date: Date, correct: Bool)] = [:]
        for a in answers {
            if let existing = latestOutcome[a.questionID], existing.date >= a.answeredAt { continue }
            latestOutcome[a.questionID] = (a.answeredAt, a.wasCorrect)
        }
        missedQuestionIDs = Set(latestOutcome.filter { !$0.value.correct }.keys)
        seenQuestionIDs = Set(latestOutcome.keys)

        let sessions = (try? context.fetch(
            FetchDescriptor<StudySession>(sortBy: [SortDescriptor(\.startedAt, order: .reverse)])
        )) ?? []
        recentSessions = Array(sessions.prefix(20))
        totalStudyTime = sessions.reduce(0) { $0 + $1.duration }

        streak = profile?.displayedStreak() ?? 0
        longestStreak = profile?.longestStreak ?? 0
    }

    /// Questions answered today, for the daily-goal ring.
    func answeredToday() -> Int {
        guard let context else { return 0 }
        let start = Calendar.current.startOfDay(for: Date())
        let descriptor = FetchDescriptor<AnswerRecord>(
            predicate: #Predicate { $0.answeredAt >= start }
        )
        return ((try? context.fetch(descriptor)) ?? []).count
    }

    var overallAccuracy: Double {
        totalAnswered > 0 ? Double(totalCorrect) / Double(totalAnswered) : 0
    }

    func readiness(for domain: Domain) -> DomainReadiness? {
        readiness.domains.first { $0.domain == domain }
    }

    // MARK: - Destructive

    /// Wipe all evidence. Exposed in Settings; always behind a confirmation.
    func resetAllProgress() {
        guard let context else { return }
        for a in (try? context.fetch(FetchDescriptor<AnswerRecord>())) ?? [] { context.delete(a) }
        for s in (try? context.fetch(FetchDescriptor<StudySession>())) ?? [] { context.delete(s) }
        profile?.currentStreak = 0
        profile?.longestStreak = 0
        profile?.lastStudyDay = nil
        save()
        refresh()
    }

    private func save() {
        try? context?.save()
    }
}
