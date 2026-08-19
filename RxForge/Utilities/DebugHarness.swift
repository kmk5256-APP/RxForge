#if DEBUG
import Foundation
import SwiftUI

/// DEBUG-only launch-argument router, for verification runs and for generating App Store
/// screenshots from real app state rather than mockups.
///
/// Compiled out of Release entirely — nothing here can ship.
///
///   xcrun simctl launch <device> com.karankohli.rxforge --seed --screen progress
///
/// Flags:
///   --seed            populate a realistic answer history before the UI appears
///   --screen <name>   home | practice | progress | topics
///   --fresh           wipe stored progress first (implies onboarding is skipped)
enum DebugHarness {

    static var isSeeding: Bool { args.contains("--seed") }
    static var isFresh: Bool { args.contains("--fresh") }

    /// Tab index for `--screen`, or nil when not specified.
    static var requestedTab: Int? {
        guard let i = args.firstIndex(of: "--screen"), args.indices.contains(i + 1) else { return nil }
        switch args[i + 1].lowercased() {
        case "home": return 0
        case "practice": return 1
        case "progress": return 2
        case "topics", "blueprint": return 3
        default: return nil
        }
    }

    /// `--quiz [quick|timed|domain3|missed]` presents a session immediately, so the quiz
    /// UI can be screenshotted without driving taps.
    static var requestedQuiz: SessionMode? {
        guard let i = args.firstIndex(of: "--quiz") else { return nil }
        let name = args.indices.contains(i + 1) ? args[i + 1].lowercased() : "quick"
        switch name {
        case "timed": return .timedBlock(count: 25)
        case "missed": return .missedReview
        case let d where d.hasPrefix("domain"):
            let n = Int(d.dropFirst("domain".count)) ?? 1
            return .domainFocus(Domain.allCases.first { $0.number == n } ?? .foundational)
        default: return .quickQuiz
        }
    }

    /// `--autoanswer N` answers N questions correctly, then answers the next one
    /// *incorrectly* and stops there — leaving the explanation revealed, which is the
    /// richer UI state to inspect.
    static var autoAnswerCount: Int? {
        guard let i = args.firstIndex(of: "--autoanswer"), args.indices.contains(i + 1) else { return nil }
        return Int(args[i + 1])
    }

    /// True when any harness flag is present — used to bypass onboarding.
    static var isActive: Bool { isSeeding || isFresh || requestedTab != nil || requestedQuiz != nil }

    /// Drive a freshly-made session forward without taps.
    static func autoAnswer(_ session: QuizSession, count: Int, manager: ProgressManager) {
        for _ in 0..<count {
            guard let q = session.currentQuestion else { return }
            session.select(q.correctIndex, progressManager: manager)
            session.advance(progressManager: manager)
        }
        // Answer the one we land on wrongly, and leave it revealed.
        if let q = session.currentQuestion {
            let wrong = q.choices.indices.first { $0 != q.correctIndex } ?? 0
            session.select(wrong, progressManager: manager)
        }
    }

    private static var args: [String] { CommandLine.arguments }

    /// Seed a plausible study history: uneven across domains, spread over the last two
    /// weeks, so the dial, confidence band, and leverage routing all have something real
    /// to display.
    ///
    /// Records are written in chronological order — `UserProgress.registerStudy` walks
    /// the streak forward day by day, so out-of-order dates would produce a nonsense
    /// streak.
    static func seed(into manager: ProgressManager) {
        let calendar = Calendar.current
        let now = Date()

        // (domain, attempts, accuracy) — deliberately uneven so "study this next" has a
        // clear and checkable answer.
        let plan: [(Domain, Int, Double)] = [
            (.foundational, 34, 0.76),
            (.medicationUse, 28, 0.68),
            (.assessmentPlanning, 46, 0.59),   // heaviest weight, weakest → should be routed to
            (.professionalPractice, 7, 0.71),
            (.managementLeadership, 5, 0.60),
        ]

        var pending: [(question: Question, correct: Bool, date: Date, seconds: Double)] = []

        for (domain, attempts, accuracy) in plan {
            let pool = QuestionBank.questions(for: domain)
            guard !pool.isEmpty else { continue }

            for i in 0..<attempts {
                let question = pool[i % pool.count]
                // Deterministic Bresenham-style distribution: yields exactly
                // floor(attempts × accuracy) correct answers, spread evenly. A naive
                // `Double(i)/100 < accuracy` marks everything correct whenever
                // attempts < accuracy × 100, which silently inflates the score.
                let wasCorrect = Int(Double(i + 1) * accuracy) > Int(Double(i) * accuracy)
                // Spread over the last 11 days, most recent first, so the trailing
                // consistency window is populated and today has activity.
                let daysAgo = i % 11
                let when = calendar.date(byAdding: .day, value: -daysAgo, to: now) ?? now
                pending.append((question, wasCorrect, when, Double(30 + (i % 40))))
            }
        }

        for entry in pending.sorted(by: { $0.date < $1.date }) {
            manager.record(question: entry.question,
                           wasCorrect: entry.correct,
                           secondsSpent: entry.seconds,
                           mode: .quickQuiz,
                           at: entry.date)
        }

        // A few sessions so the history card and total study time are populated.
        for (offset, plan) in plan.enumerated() {
            let start = calendar.date(byAdding: .day, value: -offset, to: now) ?? now
            manager.completeSession(mode: .domainFocus(plan.0),
                                    startedAt: calendar.date(byAdding: .minute, value: -22, to: start) ?? start,
                                    endedAt: start,
                                    answered: plan.1,
                                    correct: Int(Double(plan.1) * plan.2))
        }
    }
}
#endif
