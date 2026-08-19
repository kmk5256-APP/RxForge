import Foundation
import SwiftData

/// One answered question. This is the app's atomic unit of *evidence* — the Readiness
/// Score is computed entirely from these records, so nothing here may be lossy.
@Model
final class AnswerRecord {
    /// `Question.id` of the question answered. Not a relationship: questions live in
    /// code, not the store.
    var questionID: String = ""
    /// Stored as `Domain.rawValue`; use `domain` to read it.
    var domainRaw: String = Domain.foundational.rawValue
    var topic: String = ""
    var wasCorrect: Bool = false
    var answeredAt: Date = Date()
    /// Seconds spent on this question. Zero for untimed modes where it was not measured.
    var secondsSpent: Double = 0
    /// `SessionMode.id` of the session this came from.
    var sessionModeID: String = ""

    init(questionID: String,
         domain: Domain,
         topic: String,
         wasCorrect: Bool,
         answeredAt: Date = Date(),
         secondsSpent: Double = 0,
         sessionModeID: String) {
        self.questionID = questionID
        self.domainRaw = domain.rawValue
        self.topic = topic
        self.wasCorrect = wasCorrect
        self.answeredAt = answeredAt
        self.secondsSpent = secondsSpent
        self.sessionModeID = sessionModeID
    }

    var domain: Domain { Domain(rawValue: domainRaw) ?? .foundational }
}

/// One completed practice session. Kept separately from `AnswerRecord` so the app can
/// show session history and study time without recomputing from every answer.
@Model
final class StudySession {
    var startedAt: Date = Date()
    var endedAt: Date = Date()
    var modeID: String = ""
    var modeTitle: String = ""
    var questionsAnswered: Int = 0
    var questionsCorrect: Int = 0

    init(startedAt: Date,
         endedAt: Date = Date(),
         modeID: String,
         modeTitle: String,
         questionsAnswered: Int,
         questionsCorrect: Int) {
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.modeID = modeID
        self.modeTitle = modeTitle
        self.questionsAnswered = questionsAnswered
        self.questionsCorrect = questionsCorrect
    }

    var duration: TimeInterval { max(0, endedAt.timeIntervalSince(startedAt)) }

    var accuracy: Double {
        questionsAnswered > 0 ? Double(questionsCorrect) / Double(questionsAnswered) : 0
    }
}

/// Singleton-ish record holding the learner's settings and streak state. Exactly one
/// row is expected; `ProgressManager` creates it on first launch.
@Model
final class UserProgress {
    var createdAt: Date = Date()
    /// Optional target exam date, used for the "days out" readout on Home.
    var examDate: Date?
    /// Questions the learner aims to answer per day.
    var dailyGoal: Int = 20
    /// Last calendar day on which at least one question was answered.
    var lastStudyDay: Date?
    /// Consecutive days studied up to and including `lastStudyDay`.
    var currentStreak: Int = 0
    var longestStreak: Int = 0

    init(createdAt: Date = Date()) {
        self.createdAt = createdAt
    }

    /// Advance the streak for an answer recorded on `date`. Idempotent within a day.
    func registerStudy(on date: Date, calendar: Calendar = .current) {
        let today = calendar.startOfDay(for: date)
        guard let last = lastStudyDay.map({ calendar.startOfDay(for: $0) }) else {
            currentStreak = 1
            longestStreak = max(longestStreak, 1)
            lastStudyDay = today
            return
        }
        if today == last { return }                       // already counted today
        let gap = calendar.dateComponents([.day], from: last, to: today).day ?? 0
        currentStreak = (gap == 1) ? currentStreak + 1 : 1
        longestStreak = max(longestStreak, currentStreak)
        lastStudyDay = today
    }

    /// The streak as it should be *displayed* — a stored streak goes stale once the
    /// learner misses a day, and we must not show a number they have already broken.
    func displayedStreak(asOf date: Date = Date(), calendar: Calendar = .current) -> Int {
        guard let last = lastStudyDay.map({ calendar.startOfDay(for: $0) }) else { return 0 }
        let today = calendar.startOfDay(for: date)
        let gap = calendar.dateComponents([.day], from: last, to: today).day ?? 0
        return gap <= 1 ? currentStreak : 0
    }

    var daysUntilExam: Int? {
        guard let examDate else { return nil }
        let cal = Calendar.current
        return cal.dateComponents([.day],
                                  from: cal.startOfDay(for: Date()),
                                  to: cal.startOfDay(for: examDate)).day
    }
}
