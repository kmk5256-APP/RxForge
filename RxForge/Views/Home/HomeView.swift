import SwiftUI

/// The diagnostic, first. Score, what's limiting it, and the one thing worth doing next.
struct HomeView: View {
    @Environment(ProgressManager.self) private var progressManager
    @State private var session: QuizSession?
    @State private var showingScoreExplainer = false

    private var readiness: ReadinessBreakdown { progressManager.readiness }
    private var hasEvidence: Bool { readiness.totalAttempts > 0 }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 14) {
                    dial
                    if hasEvidence {
                        nextStepCard
                        compositeCard
                        domainsCard
                    } else {
                        gettingStartedCard
                    }
                    todayCard
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 28)
            }
            .background(Color.brandBackground)
            .navigationTitle("RxForge")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink { SettingsView() } label: {
                        Image(systemName: "gearshape")
                    }
                    .tint(.brandPrimary)
                }
            }
            .fullScreenCover(item: $session) { session in
                QuizView(session: session)
            }
            .sheet(isPresented: $showingScoreExplainer) {
                ScoreExplainerSheet(breakdown: readiness)
            }
        }
    }

    // MARK: - Sections

    private var dial: some View {
        VStack(spacing: 12) {
            ReadinessDial(breakdown: readiness)
                .padding(.top, 6)

            HStack(spacing: 6) {
                Text(hasEvidence ? readiness.band : "No score yet")
                    .font(.headline)
                Text("·")
                    .foregroundStyle(Color.brandSlate)
                Text(readiness.evidenceLevel.rawValue)
                    .font(.subheadline)
                    .foregroundStyle(Color.brandSlate)
            }

            Button {
                showingScoreExplainer = true
            } label: {
                Label("What is this score?", systemImage: "info.circle")
                    .font(.caption)
            }
            .tint(.brandPrimary)

            if let days = progressManager.examDate.flatMap({ _ in daysUntilExam }) {
                Text(days >= 0
                     ? "\(days) day\(days == 1 ? "" : "s") until your exam"
                     : "Exam date has passed")
                    .font(.caption)
                    .foregroundStyle(Color.brandSlate)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
    }

    private var nextStepCard: some View {
        SectionCard(title: "Study this next", systemImage: "arrow.turn.down.right") {
            if let target = readiness.highestLeverageDomain {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 10) {
                        Image(systemName: target.domain.symbol)
                            .font(.title3)
                            .foregroundStyle(target.domain.accent)
                            .frame(width: 30)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(target.domain.shortName)
                                .font(.headline)
                            Text("\(Int(target.domain.examWeight * 100))% of the exam · \(target.attempts) answered")
                                .font(.caption)
                                .foregroundStyle(Color.brandSlate)
                        }
                    }

                    Text(reasonText(for: target))
                        .font(.subheadline)
                        .foregroundStyle(Color.brandSlate)
                        .fixedSize(horizontal: false, vertical: true)

                    let gain = ReadinessEngine.headroom(from: readiness, forDomain: target.domain)
                    if gain > 0 {
                        Label("Up to +\(gain) point\(gain == 1 ? "" : "s") sitting in this domain",
                              systemImage: "arrow.up.right")
                            .font(.caption.weight(.medium))
                            .foregroundStyle(Color.brandPrimary)
                    }

                    Button("Practice \(target.domain.shortName)") {
                        start(.domainFocus(target.domain))
                    }
                    .buttonStyle(ForgeButtonStyle())
                }
            }
        }
    }

    private var compositeCard: some View {
        SectionCard(title: "What's holding it back",
                    systemImage: "slider.horizontal.3",
                    footnote: readiness.limitingFactor.guidance) {
            CompositeBreakdownView(breakdown: readiness)
        }
    }

    private var domainsCard: some View {
        SectionCard(title: "By domain", systemImage: "chart.bar.fill") {
            VStack(spacing: 16) {
                ForEach(readiness.domains.sorted { $0.domain.examWeight > $1.domain.examWeight }) { d in
                    DomainMasteryRow(readiness: d)
                }
            }
        }
    }

    private var gettingStartedCard: some View {
        SectionCard {
            EmptyStateView(
                systemImage: "hammer",
                title: "Nothing forged yet",
                message: "Answer your first ten questions and RxForge will start scoring where you actually stand.",
                actionTitle: "Start a quick quiz"
            ) {
                start(.quickQuiz)
            }
        }
    }

    private var todayCard: some View {
        SectionCard(title: "Today", systemImage: "flame.fill") {
            HStack(spacing: 10) {
                StatTile(value: "\(progressManager.answeredToday())",
                         label: "of \(progressManager.dailyGoal) today",
                         systemImage: "checkmark.circle")
                StatTile(value: "\(progressManager.streak)",
                         label: progressManager.streak == 1 ? "day streak" : "day streak",
                         systemImage: "flame")
                StatTile(value: Format.duration(progressManager.totalStudyTime),
                         label: "total study time",
                         systemImage: "clock")
            }
        }
    }

    // MARK: - Helpers

    private var daysUntilExam: Int? {
        guard let exam = progressManager.examDate else { return nil }
        let cal = Calendar.current
        return cal.dateComponents([.day],
                                  from: cal.startOfDay(for: Date()),
                                  to: cal.startOfDay(for: exam)).day
    }

    /// Why this domain and not another — the routing has to be explainable.
    private func reasonText(for target: DomainReadiness) -> String {
        if target.attempts < 5 {
            return "You've barely touched this one, and it carries \(Int(target.domain.examWeight * 100))% of the exam. Answering here tells RxForge the most."
        }
        if target.mastery < 0.6 {
            return "Your weakest domain by mastery, and a heavily weighted one. This is where points are sitting."
        }
        return "Highest leverage right now: solid weight on the exam, and still room to move."
    }

    private func start(_ mode: SessionMode) {
        session = QuizSession.make(mode: mode, progressManager: progressManager)
    }
}

/// Explains the composite in plain language, including what it is not.
struct ScoreExplainerSheet: View {
    let breakdown: ReadinessBreakdown
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text("The Readiness Score is a study-progress number between 0 and 100. It combines three things:")
                        .font(.subheadline)

                    explain("Accuracy (70%)",
                            "How often you're right, weighted by how much each domain counts on the exam. A domain worth 40% of the exam moves this far more than one worth 5%.")
                    explain("Volume (20%)",
                            "How much you've answered against a target for each domain. Getting 2 of 2 right doesn't read as 100% — the score stays near the middle until there's enough evidence to move it.")
                    explain("Consistency (10%)",
                            "How many days you've studied in the last two weeks. If you go quiet for more than a week, this decays.")

                    Divider()

                    VStack(alignment: .leading, spacing: 6) {
                        Label("The ± range", systemImage: "arrow.left.and.right")
                            .font(.subheadline.weight(.semibold))
                        Text("The band around your score is how much it could reasonably move as you answer more. It narrows as evidence accumulates. Right now it's ± \(breakdown.confidenceHalfWidth) from \(breakdown.totalAttempts) question\(breakdown.totalAttempts == 1 ? "" : "s").")
                            .font(.subheadline)
                            .foregroundStyle(Color.brandSlate)
                    }

                    Divider()

                    VStack(alignment: .leading, spacing: 6) {
                        Label("What it is not", systemImage: "exclamationmark.triangle")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Color.brandPrimary)
                        Text("This is not a predicted NAPLEX score, a percentile, or a probability of passing. It measures your progress in this app against this app's question bank. No study tool can tell you whether you'll pass.")
                            .font(.subheadline)
                            .foregroundStyle(Color.brandSlate)
                    }
                }
                .padding(20)
            }
            .background(Color.brandBackground)
            .navigationTitle("Your score")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }.tint(.brandPrimary)
                }
            }
        }
    }

    private func explain(_ title: String, _ body: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.subheadline.weight(.semibold))
            Text(body)
                .font(.subheadline)
                .foregroundStyle(Color.brandSlate)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    HomeView().environment(ProgressManager())
}
