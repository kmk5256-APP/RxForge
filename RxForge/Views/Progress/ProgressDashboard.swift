import SwiftUI

/// The evidence behind the score: totals, per-domain detail, what would move the number
/// most, and session history.
struct ProgressDashboard: View {
    @Environment(ProgressManager.self) private var progressManager

    private var readiness: ReadinessBreakdown { progressManager.readiness }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 14) {
                    if readiness.totalAttempts == 0 {
                        SectionCard {
                            EmptyStateView(systemImage: "chart.line.uptrend.xyaxis",
                                           title: "No progress yet",
                                           message: "Answer some questions and this fills in with your domain breakdown, streak, and study time.")
                        }
                    } else {
                        totalsGrid
                        leverageCard
                        domainsCard
                        historyCard
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 28)
            }
            .background(Color.brandBackground)
            .navigationTitle("Progress")
        }
    }

    // MARK: - Sections

    private var totalsGrid: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                StatTile(value: "\(readiness.totalAttempts)",
                         label: "questions answered",
                         systemImage: "list.bullet")
                StatTile(value: Format.percent(progressManager.overallAccuracy),
                         label: "overall accuracy",
                         systemImage: "target")
                StatTile(value: "\(progressManager.streak)",
                         label: "day streak",
                         systemImage: "flame")
            }
            HStack(spacing: 10) {
                StatTile(value: Format.duration(progressManager.totalStudyTime),
                         label: "total study time",
                         systemImage: "clock")
                StatTile(value: "\(progressManager.missedQuestionIDs.count)",
                         label: "in missed review",
                         systemImage: "arrow.counterclockwise")
                StatTile(value: "\(progressManager.longestStreak)",
                         label: "longest streak",
                         systemImage: "trophy")
            }
        }
    }

    private var leverageCard: some View {
        SectionCard(title: "What would move your score most",
                    systemImage: "arrow.up.right",
                    footnote: "Points available if each domain reached \(Int(ReadinessEngine.headroomTarget * 100))% mastery with its evidence target met. Heavily weighted domains hold more.") {
            VStack(spacing: 10) {
                let ranked = readiness.domains
                    .sorted { $0.leverage > $1.leverage }
                    .prefix(3)

                ForEach(Array(ranked)) { d in
                    let gain = ReadinessEngine.headroom(from: readiness, forDomain: d.domain)
                    HStack(spacing: 10) {
                        Image(systemName: d.domain.symbol)
                            .font(.caption)
                            .foregroundStyle(d.domain.accent)
                            .frame(width: 18)

                        VStack(alignment: .leading, spacing: 1) {
                            Text(d.domain.shortName)
                                .font(.subheadline.weight(.medium))
                            Text("\(d.attempts) of \(ReadinessEngine.evidenceTarget(for: d.domain)) toward full evidence")
                                .font(.caption2)
                                .foregroundStyle(Color.brandSlate)
                        }

                        Spacer(minLength: 0)

                        Text(gain > 0 ? "+\(gain)" : "—")
                            .font(.subheadline.weight(.bold))
                            .monospacedDigit()
                            .foregroundStyle(gain > 0 ? Color.brandPrimary : Color.brandSlate)
                    }
                }
            }
        }
    }

    private var domainsCard: some View {
        SectionCard(title: "Domain detail", systemImage: "square.grid.2x2") {
            VStack(spacing: 16) {
                ForEach(readiness.domains.sorted { $0.domain.number < $1.domain.number }) { d in
                    NavigationLink {
                        DomainDetailView(domain: d.domain)
                    } label: {
                        DomainMasteryRow(readiness: d, showsChevron: true)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var historyCard: some View {
        SectionCard(title: "Recent sessions", systemImage: "clock.arrow.circlepath") {
            if progressManager.recentSessions.isEmpty {
                Text("No completed sessions yet.")
                    .font(.subheadline)
                    .foregroundStyle(Color.brandSlate)
            } else {
                VStack(spacing: 12) {
                    ForEach(progressManager.recentSessions.prefix(8)) { s in
                        HStack(spacing: 10) {
                            VStack(alignment: .leading, spacing: 1) {
                                Text(s.modeTitle)
                                    .font(.subheadline.weight(.medium))
                                Text("\(Format.shortDate.string(from: s.startedAt)) · \(Format.duration(s.duration))")
                                    .font(.caption2)
                                    .foregroundStyle(Color.brandSlate)
                            }
                            Spacer(minLength: 0)
                            Text("\(s.questionsCorrect)/\(s.questionsAnswered)")
                                .font(.subheadline.weight(.semibold))
                                .monospacedDigit()
                                .foregroundStyle(Color.mastery(s.accuracy))
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ProgressDashboard().environment(ProgressManager())
}
