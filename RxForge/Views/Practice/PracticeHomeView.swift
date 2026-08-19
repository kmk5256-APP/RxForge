import SwiftUI

/// Mode picker. Every mode here feeds the same evidence store — there is no
/// "practice mode" that doesn't count.
struct PracticeHomeView: View {
    @Environment(ProgressManager.self) private var progressManager
    @State private var session: QuizSession?
    @State private var showingEmptyMissedAlert = false

    private var missedCount: Int { progressManager.missedQuestionIDs.count }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 14) {
                    modeCard(.quickQuiz,
                             detail: "\(SessionMode.quickQuiz.questionCount) questions drawn across all five domains in exam proportion.")

                    modeCard(.timedBlock(count: 25),
                             detail: "A longer blueprint-weighted block with a running clock. The closest thing here to sitting the real thing.")

                    modeCard(.missedReview,
                             detail: missedCount == 0
                             ? "Nothing to review yet — questions you miss land here."
                             : "\(missedCount) question\(missedCount == 1 ? "" : "s") waiting. Getting one right retires it.",
                             disabled: missedCount == 0)

                    SectionCard(title: "By domain", systemImage: "square.grid.2x2") {
                        VStack(spacing: 10) {
                            ForEach(Domain.allCases) { domain in
                                Button {
                                    start(.domainFocus(domain))
                                } label: {
                                    domainRow(domain)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    Text("\(QuestionBank.all.count) questions in this version, distributed across the five content domains in the same proportions as the exam.")
                        .font(.caption)
                        .foregroundStyle(Color.brandSlate)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.top, 4)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 28)
            }
            .background(Color.brandBackground)
            .navigationTitle("Practice")
            .fullScreenCover(item: $session) { session in
                QuizView(session: session)
            }
        }
    }

    // MARK: - Pieces

    private func modeCard(_ mode: SessionMode, detail: String, disabled: Bool = false) -> some View {
        Button {
            start(mode)
        } label: {
            SectionCard {
                HStack(alignment: .top, spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 11, style: .continuous)
                            .fill(Color.brandPrimary.opacity(disabled ? 0.06 : 0.14))
                            .frame(width: 42, height: 42)
                        Image(systemName: mode.symbol)
                            .font(.title3)
                            .foregroundStyle(disabled ? Color.brandSlate : Color.brandPrimary)
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        Text(mode.title)
                            .font(.headline)
                            .foregroundStyle(disabled ? Color.brandSlate : Color.primary)
                        Text(detail)
                            .font(.caption)
                            .foregroundStyle(Color.brandSlate)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Spacer(minLength: 0)

                    if !disabled {
                        Image(systemName: "chevron.right")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Color.brandSlate.opacity(0.6))
                    }
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(disabled)
    }

    private func domainRow(_ domain: Domain) -> some View {
        let available = QuestionBank.count(for: domain)
        let answered = progressManager.readiness(for: domain)?.attempts ?? 0

        return HStack(spacing: 12) {
            Image(systemName: domain.symbol)
                .font(.subheadline)
                .foregroundStyle(domain.accent)
                .frame(width: 22)

            VStack(alignment: .leading, spacing: 1) {
                Text(domain.shortName)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Color.primary)
                Text("\(available) question\(available == 1 ? "" : "s") · \(answered) attempt\(answered == 1 ? "" : "s")")
                    .font(.caption2)
                    .foregroundStyle(Color.brandSlate)
            }

            Spacer(minLength: 0)

            Text("\(Int(domain.examWeight * 100))%")
                .font(.caption.weight(.semibold))
                .monospacedDigit()
                .foregroundStyle(Color.brandSlate)

            Image(systemName: "chevron.right")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(Color.brandSlate.opacity(0.5))
        }
        .contentShape(Rectangle())
    }

    private func start(_ mode: SessionMode) {
        let new = QuizSession.make(mode: mode, progressManager: progressManager)
        guard !new.isEmpty else { return }
        session = new
    }
}

#Preview {
    PracticeHomeView().environment(ProgressManager())
}
