import SwiftUI

/// The session runner. Answer is committed on tap, explanation reveals immediately,
/// and the record is written at that moment — quitting mid-session never loses evidence.
struct QuizView: View {
    @Bindable var session: QuizSession
    @Environment(ProgressManager.self) private var progressManager
    @Environment(\.dismiss) private var dismiss

    @State private var showingQuitConfirm = false
    @State private var showingResults = false

    private let ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            Group {
                if session.isEmpty {
                    EmptyStateView(systemImage: "tray",
                                   title: "No questions available",
                                   message: "There aren't any questions for this mode yet.",
                                   actionTitle: "Close") { dismiss() }
                } else {
                    content
                }
            }
            .background(Color.brandBackground)
            .navigationTitle(session.mode.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Quit") {
                        if session.answeredCount > 0 && !session.isFinished {
                            showingQuitConfirm = true
                        } else {
                            dismiss()
                        }
                    }
                    .tint(.brandSlate)
                }
                if session.mode.isTimed {
                    ToolbarItem(placement: .topBarTrailing) {
                        Label(timeString, systemImage: "timer")
                            .font(.subheadline.weight(.medium))
                            .monospacedDigit()
                            .foregroundStyle(Color.brandSlate)
                    }
                }
            }
            .confirmationDialog("End this session?",
                                isPresented: $showingQuitConfirm,
                                titleVisibility: .visible) {
                Button("End session", role: .destructive) {
                    session.finish(progressManager: progressManager)
                    showingResults = true
                }
                Button("Keep going", role: .cancel) {}
            } message: {
                Text("Your \(session.answeredCount) answered question\(session.answeredCount == 1 ? "" : "s") are already saved.")
            }
            .fullScreenCover(isPresented: $showingResults) {
                QuizResultView(session: session) { dismiss() }
            }
            .task {
                // A session can arrive already finished (re-presented, or driven by the
                // debug harness) — go straight to results rather than showing a dead
                // question with a disabled button.
                if session.isFinished { showingResults = true }
            }
            .onReceive(ticker) { _ in
                guard session.mode.isTimed, !session.isFinished else { return }
                session.elapsed = Date().timeIntervalSince(session.startedAt)
            }
        }
        .interactiveDismissDisabled(session.answeredCount > 0)
    }

    // MARK: - Content

    private var content: some View {
        VStack(spacing: 0) {
            progressBar

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    if let question = session.currentQuestion {
                        header(for: question)
                        prompt(question)
                        choices(for: question)
                        if session.isRevealed {
                            explanation(for: question)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 24)
            }

            footer
        }
    }

    private var progressBar: some View {
        VStack(spacing: 6) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.brandGraphite.opacity(0.10))
                    Capsule()
                        .fill(LinearGradient.ember)
                        .frame(width: max(2, geo.size.width * fractionComplete))
                        .animation(.easeOut(duration: 0.25), value: fractionComplete)
                }
            }
            .frame(height: 4)

            HStack {
                Text("Question \(session.currentIndex + 1) of \(session.questions.count)")
                Spacer()
                if session.answeredCount > 0 {
                    Text("\(session.correctCount)/\(session.answeredCount) correct")
                }
            }
            .font(.caption2)
            .monospacedDigit()
            .foregroundStyle(Color.brandSlate)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 10)
    }

    private func header(for question: Question) -> some View {
        HStack(spacing: 8) {
            Label(question.domain.shortName, systemImage: question.domain.symbol)
                .font(.caption2.weight(.medium))
                .padding(.horizontal, 9)
                .padding(.vertical, 5)
                .background(question.domain.accent.opacity(0.14),
                            in: Capsule())
                .foregroundStyle(question.domain.accent)

            Text(question.topic)
                .font(.caption2)
                .foregroundStyle(Color.brandSlate)
                .lineLimit(1)

            Spacer(minLength: 0)

            Text(question.difficulty.label)
                .font(.caption2)
                .foregroundStyle(Color.brandSlate.opacity(0.8))
        }
    }

    private func prompt(_ question: Question) -> some View {
        Text(question.prompt)
            .font(.title3.weight(.medium))
            .foregroundStyle(Color.primary)
            .fixedSize(horizontal: false, vertical: true)
    }

    private func choices(for question: Question) -> some View {
        VStack(spacing: 10) {
            ForEach(question.choices.indices, id: \.self) { index in
                ChoiceRow(text: question.choices[index],
                          letter: letter(index),
                          state: state(for: index, question: question)) {
                    guard !session.isRevealed else { return }
                    session.select(index, progressManager: progressManager)
                }
            }
        }
    }

    private func explanation(for question: Question) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(isCurrentCorrect(question) ? "Correct" : "Not quite",
                  systemImage: isCurrentCorrect(question) ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(isCurrentCorrect(question) ? Color.masteryStrong : Color.brandPrimary)

            if !isCurrentCorrect(question) {
                Text("Answer: \(letter(question.correctIndex)). \(question.correctAnswer)")
                    .font(.subheadline.weight(.medium))
                    .fixedSize(horizontal: false, vertical: true)
            }

            Text(question.explanation)
                .font(.subheadline)
                .foregroundStyle(Color.brandSlate)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color.brandSurface, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .transition(.opacity.combined(with: .move(edge: .bottom)))
    }

    private var footer: some View {
        VStack(spacing: 0) {
            Divider()
            Button(session.isRevealed
                   ? (session.isLastQuestion ? "See results" : "Next question")
                   : "Choose an answer") {
                guard session.isRevealed else { return }
                if session.isLastQuestion {
                    session.advance(progressManager: progressManager)
                    showingResults = true
                } else {
                    withAnimation(.easeOut(duration: 0.2)) {
                        session.advance(progressManager: progressManager)
                    }
                }
            }
            .buttonStyle(ForgeButtonStyle())
            .disabled(!session.isRevealed)
            .opacity(session.isRevealed ? 1 : 0.45)
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 8)
        }
        .background(.regularMaterial)
    }

    // MARK: - Helpers

    private var fractionComplete: Double {
        guard !session.questions.isEmpty else { return 0 }
        let done = Double(session.currentIndex) + (session.isRevealed ? 1 : 0)
        return min(1, done / Double(session.questions.count))
    }

    private var timeString: String {
        let total = Int(session.elapsed)
        return String(format: "%d:%02d", total / 60, total % 60)
    }

    private func letter(_ index: Int) -> String {
        String(UnicodeScalar(65 + index) ?? "A")
    }

    private func isCurrentCorrect(_ question: Question) -> Bool {
        guard let chosen = session.selectedChoice else { return false }
        return question.isCorrect(chosen)
    }

    private func state(for index: Int, question: Question) -> ChoiceRow.State {
        guard session.isRevealed, let chosen = session.selectedChoice else { return .unanswered }
        if index == question.correctIndex { return .correct }
        if index == chosen { return .incorrect }
        return .dimmed
    }
}

/// One answer option.
struct ChoiceRow: View {
    enum State { case unanswered, correct, incorrect, dimmed }

    let text: String
    let letter: String
    let state: State
    let action: () -> Void

    private var border: Color {
        switch state {
        case .unanswered: return Color.brandGraphite.opacity(0.14)
        case .correct: return .masteryStrong
        case .incorrect: return .brandPrimary
        case .dimmed: return Color.brandGraphite.opacity(0.10)
        }
    }

    private var fill: Color {
        switch state {
        case .correct: return Color.masteryStrong.opacity(0.10)
        case .incorrect: return Color.brandPrimary.opacity(0.10)
        default: return Color.brandSurface
        }
    }

    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 12) {
                Text(letter)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(state == .unanswered || state == .dimmed
                                     ? Color.brandSlate : border)
                    .frame(width: 22, height: 22)
                    .background(
                        Circle().stroke(border, lineWidth: 1.5)
                    )

                Text(text)
                    .font(.subheadline)
                    .foregroundStyle(Color.primary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if state == .correct {
                    Image(systemName: "checkmark")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(Color.masteryStrong)
                } else if state == .incorrect {
                    Image(systemName: "xmark")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(Color.brandPrimary)
                }
            }
            .padding(14)
            .background(fill, in: RoundedRectangle(cornerRadius: 13, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .stroke(border, lineWidth: state == .unanswered ? 1 : 1.6)
            )
            .opacity(state == .dimmed ? 0.55 : 1)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(letter). \(text)")
        .accessibilityAddTraits(state == .correct ? [.isSelected] : [])
    }
}
