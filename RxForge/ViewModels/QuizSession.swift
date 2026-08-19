import Foundation
import Observation

/// Runs one practice session: holds the drawn questions, tracks the answer to each, and
/// reports results. Owns no persistence — it hands each answer to `ProgressManager`.
@Observable
final class QuizSession: Identifiable {

    /// Distinct per session instance so `.fullScreenCover(item:)` presents each one.
    let id = UUID()
    let mode: SessionMode
    let questions: [Question]
    let startedAt: Date

    private(set) var currentIndex = 0
    /// Selected choice index per question index. Nil until answered.
    private(set) var selections: [Int: Int] = [:]
    /// True once the learner commits an answer and the explanation is revealed.
    private(set) var isRevealed = false
    private(set) var isFinished = false

    /// Wall-clock seconds elapsed, updated by the view's timer for timed modes.
    var elapsed: TimeInterval = 0

    private var questionStartedAt: Date

    init(mode: SessionMode, questions: [Question], now: Date = Date()) {
        self.mode = mode
        self.questions = questions
        self.startedAt = now
        self.questionStartedAt = now
    }

    // MARK: - Derived

    var currentQuestion: Question? {
        questions.indices.contains(currentIndex) ? questions[currentIndex] : nil
    }

    var isEmpty: Bool { questions.isEmpty }

    var progress: Double {
        questions.isEmpty ? 0 : Double(currentIndex) / Double(questions.count)
    }

    var answeredCount: Int { selections.count }

    var correctCount: Int {
        selections.reduce(0) { total, entry in
            let (index, choice) = entry
            guard questions.indices.contains(index) else { return total }
            return total + (questions[index].isCorrect(choice) ? 1 : 0)
        }
    }

    var accuracy: Double {
        answeredCount > 0 ? Double(correctCount) / Double(answeredCount) : 0
    }

    var selectedChoice: Int? { selections[currentIndex] }

    var isLastQuestion: Bool { currentIndex >= questions.count - 1 }

    /// Questions answered incorrectly, for the results screen.
    var missedQuestions: [(question: Question, chosen: Int)] {
        selections.compactMap { index, choice in
            guard questions.indices.contains(index) else { return nil }
            let q = questions[index]
            return q.isCorrect(choice) ? nil : (q, choice)
        }
        .sorted { $0.question.id < $1.question.id }
    }

    // MARK: - Actions

    /// Commit an answer, reveal the explanation, and persist the record.
    /// Ignored if this question has already been answered — answers are final.
    @discardableResult
    func select(_ choice: Int, progressManager: ProgressManager, now: Date = Date()) -> Bool {
        guard !isRevealed, let question = currentQuestion else { return false }

        selections[currentIndex] = choice
        isRevealed = true

        let seconds = now.timeIntervalSince(questionStartedAt)
        progressManager.record(question: question,
                               wasCorrect: question.isCorrect(choice),
                               secondsSpent: max(0, seconds),
                               mode: mode,
                               at: now)
        return question.isCorrect(choice)
    }

    /// Move to the next question, or finish the session.
    func advance(progressManager: ProgressManager, now: Date = Date()) {
        guard isRevealed else { return }
        if isLastQuestion {
            finish(progressManager: progressManager, now: now)
        } else {
            currentIndex += 1
            isRevealed = selections[currentIndex] != nil
            questionStartedAt = now
        }
    }

    /// End the session early or on completion. Safe to call twice.
    func finish(progressManager: ProgressManager, now: Date = Date()) {
        guard !isFinished else { return }
        isFinished = true
        progressManager.completeSession(mode: mode,
                                        startedAt: startedAt,
                                        endedAt: now,
                                        answered: answeredCount,
                                        correct: correctCount)
    }

    /// Build a session for `mode`, drawing from the bank against the learner's history.
    static func make(mode: SessionMode, progressManager: ProgressManager) -> QuizSession {
        let drawn = QuestionBank.sample(for: mode,
                                        missedIDs: progressManager.missedQuestionIDs,
                                        seenIDs: progressManager.seenQuestionIDs)
        return QuizSession(mode: mode, questions: drawn)
    }
}
