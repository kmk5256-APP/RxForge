import SwiftUI

/// End-of-session summary. Shows what the session did to the Readiness Score, since
/// that is the thing the app is actually about.
struct QuizResultView: View {
    let session: QuizSession
    let onClose: () -> Void

    @Environment(ProgressManager.self) private var progressManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 14) {
                    scoreHeader
                    readinessCard
                    if !session.missedQuestions.isEmpty {
                        missedCard
                    }
                    domainBreakdown
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 28)
            }
            .background(Color.brandBackground)
            .navigationTitle("Session complete")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                        onClose()
                    }
                    .tint(.brandPrimary)
                }
            }
        }
        .interactiveDismissDisabled()
    }

    // MARK: - Sections

    private var scoreHeader: some View {
        VStack(spacing: 8) {
            Text("\(session.correctCount)/\(session.answeredCount)")
                .font(.system(size: 52, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(LinearGradient.ember)

            Text(Format.percent(session.accuracy) + " correct")
                .font(.headline)
                .foregroundStyle(Color.brandSlate)

            Text(encouragement)
                .font(.subheadline)
                .foregroundStyle(Color.brandSlate)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.top, 2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }

    private var readinessCard: some View {
        SectionCard(title: "Readiness now", systemImage: "gauge.medium") {
            HStack(spacing: 16) {
                ReadinessDial(breakdown: progressManager.readiness,
                              diameter: 104,
                              showsBand: true)

                VStack(alignment: .leading, spacing: 6) {
                    Text(progressManager.readiness.band)
                        .font(.headline)
                    Text(progressManager.readiness.evidenceLevel.explanation)
                        .font(.caption)
                        .foregroundStyle(Color.brandSlate)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("\(progressManager.readiness.totalAttempts) question\(progressManager.readiness.totalAttempts == 1 ? "" : "s") answered in total")
                        .font(.caption2)
                        .foregroundStyle(Color.brandSlate.opacity(0.8))
                }
            }
        }
    }

    private var missedCard: some View {
        SectionCard(title: "Worth another look",
                    systemImage: "arrow.counterclockwise",
                    footnote: "These are queued in Missed Questions until you get them right.") {
            VStack(spacing: 14) {
                ForEach(Array(session.missedQuestions.enumerated()), id: \.offset) { _, item in
                    VStack(alignment: .leading, spacing: 5) {
                        Text(item.question.prompt)
                            .font(.subheadline.weight(.medium))
                            .fixedSize(horizontal: false, vertical: true)
                        Text("Answer: \(item.question.correctAnswer)")
                            .font(.caption)
                            .foregroundStyle(Color.masteryStrong)
                            .fixedSize(horizontal: false, vertical: true)
                        Text(item.question.explanation)
                            .font(.caption)
                            .foregroundStyle(Color.brandSlate)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    private var domainBreakdown: some View {
        let counts = Dictionary(grouping: session.selections.compactMap { index, choice -> (Domain, Bool)? in
            guard session.questions.indices.contains(index) else { return nil }
            let q = session.questions[index]
            return (q.domain, q.isCorrect(choice))
        }, by: { $0.0 })

        return SectionCard(title: "This session by domain", systemImage: "chart.bar") {
            VStack(spacing: 10) {
                ForEach(Domain.allCases.filter { counts[$0] != nil }) { domain in
                    let results = counts[domain] ?? []
                    let correct = results.filter(\.1).count
                    HStack(spacing: 10) {
                        Image(systemName: domain.symbol)
                            .font(.caption)
                            .foregroundStyle(domain.accent)
                            .frame(width: 18)
                        Text(domain.shortName)
                            .font(.subheadline)
                        Spacer(minLength: 0)
                        Text("\(correct)/\(results.count)")
                            .font(.subheadline.weight(.semibold))
                            .monospacedDigit()
                            .foregroundStyle(Color.brandSlate)
                    }
                }
            }
        }
    }

    private var encouragement: String {
        switch session.accuracy {
        case 0..<0.5:
            return "A rough one — but every miss here is a gap found before exam day. Read the explanations before moving on."
        case 0.5..<0.7:
            return "Middle of the road. The explanations on what you missed are where the points are."
        case 0.7..<0.9:
            return "Solid work. Keep the volume up so the score has enough evidence to move."
        default:
            return "Strong session. Make sure the weighted domains are getting the same attention."
        }
    }
}
