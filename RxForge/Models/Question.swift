import Foundation

/// A single multiple-choice practice question.
///
/// Questions are value types loaded from `Data/QuestionBank.swift`. They are never
/// persisted — only `AnswerRecord`s referencing `Question.id` are (see
/// `PersistentModels.swift`), so the bank can grow between releases without a
/// SwiftData migration.
struct Question: Identifiable, Hashable, Codable {
    /// Stable identifier. Must never be reused or renumbered across releases — answer
    /// history is keyed on it.
    let id: String
    let domain: Domain
    /// One of `domain.topics`.
    let topic: String
    let difficulty: Difficulty
    let prompt: String
    let choices: [String]
    /// Index into `choices`.
    let correctIndex: Int
    /// Shown after the learner answers. Explains why the key is right *and* why the
    /// plausible distractor is wrong — a bank without this is just a scoreboard.
    let explanation: String

    enum Difficulty: Int, Codable, CaseIterable, Comparable {
        case recall = 1
        case application = 2
        case analysis = 3

        var label: String {
            switch self {
            case .recall: return "Recall"
            case .application: return "Application"
            case .analysis: return "Analysis"
            }
        }

        static func < (lhs: Difficulty, rhs: Difficulty) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
    }

    var correctAnswer: String { choices[correctIndex] }

    func isCorrect(_ index: Int) -> Bool { index == correctIndex }
}

/// How a practice session was assembled. Drives sampling in `QuizSession`.
enum SessionMode: Hashable, Identifiable {
    /// Ten questions sampled across all domains, proportional to blueprint weight.
    case quickQuiz
    /// A longer, timed, blueprint-weighted block — the closest thing to exam conditions.
    case timedBlock(count: Int)
    /// Every question drawn from one domain.
    case domainFocus(Domain)
    /// Only questions previously answered incorrectly.
    case missedReview

    var id: String {
        switch self {
        case .quickQuiz: return "quick"
        case .timedBlock(let n): return "timed-\(n)"
        case .domainFocus(let d): return "domain-\(d.rawValue)"
        case .missedReview: return "missed"
        }
    }

    var title: String {
        switch self {
        case .quickQuiz: return "Quick Quiz"
        case .timedBlock(let n): return "Timed Block · \(n)"
        case .domainFocus(let d): return d.shortName
        case .missedReview: return "Missed Questions"
        }
    }

    var subtitle: String {
        switch self {
        case .quickQuiz:
            return "10 questions, weighted like the exam"
        case .timedBlock(let n):
            return "\(n) questions against the clock"
        case .domainFocus(let d):
            return "Everything from domain \(d.number)"
        case .missedReview:
            return "Only what you got wrong"
        }
    }

    var symbol: String {
        switch self {
        case .quickQuiz: return "bolt.fill"
        case .timedBlock: return "timer"
        case .domainFocus: return "target"
        case .missedReview: return "arrow.counterclockwise"
        }
    }

    /// Timed modes show a running clock and record time per question.
    var isTimed: Bool {
        if case .timedBlock = self { return true }
        return false
    }

    /// Number of questions to draw, where fixed.
    var questionCount: Int {
        switch self {
        case .quickQuiz: return 10
        case .timedBlock(let n): return n
        case .domainFocus: return 15
        case .missedReview: return 20
        }
    }
}
