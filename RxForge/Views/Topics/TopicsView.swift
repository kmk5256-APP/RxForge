import SwiftUI

/// The blueprint, as a browsable thing. Shows the five domains at their real exam
/// weights so the learner can see where the exam's mass actually sits.
struct TopicsView: View {
    @Environment(ProgressManager.self) private var progressManager

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 14) {
                    weightChart

                    ForEach(Domain.allCases) { domain in
                        NavigationLink {
                            DomainDetailView(domain: domain)
                        } label: {
                            domainCard(domain)
                        }
                        .buttonStyle(.plain)
                    }

                    Text("Domain names and weights are from the NAPLEX Content Outline effective May 1, 2025. Weights are approximate. NAPLEX® is a registered trademark of the National Association of Boards of Pharmacy; RxForge is not affiliated with or endorsed by NABP.")
                        .font(.caption2)
                        .foregroundStyle(Color.brandSlate)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 12)
                        .padding(.top, 6)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 28)
            }
            .background(Color.brandBackground)
            .navigationTitle("Blueprint")
        }
    }

    private var weightChart: some View {
        SectionCard(title: "Where the exam's weight sits",
                    systemImage: "chart.pie",
                    footnote: "Approximately 200 scored questions. Domain 3 alone is about 80 of them.") {
            VStack(spacing: 10) {
                // A single stacked bar reads the proportions faster than five separate ones.
                GeometryReader { geo in
                    HStack(spacing: 2) {
                        ForEach(Domain.allCases) { domain in
                            Rectangle()
                                .fill(domain.accent)
                                .frame(width: max(2, (geo.size.width - 8) * domain.examWeight))
                        }
                    }
                    .clipShape(Capsule())
                }
                .frame(height: 14)

                VStack(spacing: 6) {
                    ForEach(Domain.allCases) { domain in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(domain.accent)
                                .frame(width: 8, height: 8)
                            Text("\(domain.number). \(domain.shortName)")
                                .font(.caption)
                                .foregroundStyle(Color.primary)
                            Spacer(minLength: 0)
                            Text("\(Int(domain.examWeight * 100))% · ~\(domain.approximateQuestionCount) Q")
                                .font(.caption2)
                                .monospacedDigit()
                                .foregroundStyle(Color.brandSlate)
                        }
                    }
                }
            }
        }
    }

    private func domainCard(_ domain: Domain) -> some View {
        let readiness = progressManager.readiness(for: domain)

        return SectionCard {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(domain.accent.opacity(0.14))
                            .frame(width: 38, height: 38)
                        Image(systemName: domain.symbol)
                            .font(.body)
                            .foregroundStyle(domain.accent)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Domain \(domain.number)")
                            .font(.caption2.weight(.semibold))
                            .textCase(.uppercase)
                            .kerning(0.5)
                            .foregroundStyle(Color.brandSlate)
                        Text(domain.shortName)
                            .font(.headline)
                            .foregroundStyle(Color.primary)
                    }

                    Spacer(minLength: 0)

                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.brandSlate.opacity(0.6))
                }

                Text(domain.summary)
                    .font(.caption)
                    .foregroundStyle(Color.brandSlate)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 6) {
                    tag("\(Int(domain.examWeight * 100))% of exam")
                    tag("\(QuestionBank.count(for: domain)) questions")
                    if let r = readiness, r.attempts > 0 {
                        tag("\(Format.percent(r.mastery)) mastery")
                    }
                }
            }
        }
    }

    private func tag(_ text: String) -> some View {
        Text(text)
            .font(.caption2)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.brandGraphite.opacity(0.07), in: Capsule())
            .foregroundStyle(Color.brandSlate)
    }
}

/// One domain: what it covers, how the learner is doing in it, and a way in.
struct DomainDetailView: View {
    let domain: Domain
    @Environment(ProgressManager.self) private var progressManager
    @State private var session: QuizSession?

    private var readiness: DomainReadiness? { progressManager.readiness(for: domain) }

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                SectionCard {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 10) {
                            Image(systemName: domain.symbol)
                                .font(.title2)
                                .foregroundStyle(domain.accent)
                            VStack(alignment: .leading, spacing: 1) {
                                Text("Domain \(domain.number) · \(Int(domain.examWeight * 100))% of the exam")
                                    .font(.caption)
                                    .foregroundStyle(Color.brandSlate)
                                Text("~\(domain.approximateQuestionCount) scored questions")
                                    .font(.caption2)
                                    .foregroundStyle(Color.brandSlate.opacity(0.8))
                            }
                        }

                        if let subtitle = domain.subtitle {
                            Text(subtitle)
                                .font(.caption)
                                .foregroundStyle(Color.brandSlate)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        Text(domain.summary)
                            .font(.subheadline)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }

                if let r = readiness {
                    SectionCard(title: "Your standing", systemImage: "gauge.medium") {
                        VStack(spacing: 14) {
                            DomainMasteryRow(readiness: r)

                            HStack(spacing: 10) {
                                StatTile(value: "\(r.attempts)", label: "answered")
                                StatTile(value: r.attempts > 0 ? Format.percent(r.rawAccuracy) : "—",
                                         label: "raw accuracy")
                                StatTile(value: Format.percent(r.coverage), label: "evidence target")
                            }

                            if r.isUnderEvidenced {
                                Text("Fewer than five answered here. The mastery figure sits near the middle by design until there's enough evidence to move it.")
                                    .font(.caption)
                                    .foregroundStyle(Color.brandSlate)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }

                SectionCard(title: "Topics", systemImage: "list.bullet",
                            footnote: "RxForge's paraphrase of the subdomain structure, not a reproduction of NABP's outline.") {
                    VStack(alignment: .leading, spacing: 8) {
                        let covered = QuestionBank.coveredTopics(for: domain)
                        ForEach(domain.topics, id: \.self) { topic in
                            HStack(spacing: 8) {
                                Image(systemName: covered.contains(topic) ? "circle.fill" : "circle")
                                    .font(.system(size: 6))
                                    .foregroundStyle(covered.contains(topic)
                                                     ? domain.accent : Color.brandSlate.opacity(0.4))
                                Text(topic)
                                    .font(.subheadline)
                                    .foregroundStyle(covered.contains(topic)
                                                     ? Color.primary : Color.brandSlate)
                                Spacer(minLength: 0)
                            }
                        }
                    }
                }

                Button("Practice this domain") {
                    session = QuizSession.make(mode: .domainFocus(domain),
                                               progressManager: progressManager)
                }
                .buttonStyle(ForgeButtonStyle())
                .padding(.top, 2)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 28)
        }
        .background(Color.brandBackground)
        .navigationTitle(domain.shortName)
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(item: $session) { session in
            QuizView(session: session)
        }
    }
}

#Preview {
    TopicsView().environment(ProgressManager())
}
