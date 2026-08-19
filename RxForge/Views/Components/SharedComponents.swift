import SwiftUI

// Small building blocks shared across screens. Anything used by two or more screens
// belongs here rather than being duplicated.

/// A titled card. The standard container for everything on Home and Progress.
struct SectionCard<Content: View>: View {
    var title: String?
    var systemImage: String?
    var footnote: String?
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            if let title {
                Label {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .textCase(.uppercase)
                        .kerning(0.6)
                } icon: {
                    if let systemImage {
                        Image(systemName: systemImage)
                            .font(.caption)
                    }
                }
                .foregroundStyle(Color.brandSlate)
            }

            content

            if let footnote {
                Text(footnote)
                    .font(.caption)
                    .foregroundStyle(Color.brandSlate)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.brandSurface, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

/// A horizontal bar showing one domain's mastery, with its blueprint weight and the
/// evidence behind it.
struct DomainMasteryRow: View {
    let readiness: DomainReadiness
    var showsChevron = false

    private var barColor: Color {
        readiness.isUnderEvidenced ? Color.masteryLow.opacity(0.6) : .mastery(readiness.mastery)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Image(systemName: readiness.domain.symbol)
                    .font(.caption)
                    .foregroundStyle(readiness.domain.accent)
                    .frame(width: 16)

                Text(readiness.domain.shortName)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Color.primary)
                    .lineLimit(1)

                Spacer(minLength: 6)

                if readiness.isUnderEvidenced {
                    Text("Not enough data")
                        .font(.caption2)
                        .foregroundStyle(Color.brandSlate)
                } else {
                    Text("\(Int((readiness.mastery * 100).rounded()))%")
                        .font(.subheadline.weight(.semibold))
                        .monospacedDigit()
                        .foregroundStyle(Color.primary)
                }

                if showsChevron {
                    Image(systemName: "chevron.right")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(Color.brandSlate.opacity(0.6))
                }
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.brandGraphite.opacity(0.10))
                    Capsule()
                        .fill(barColor)
                        .frame(width: max(3, geo.size.width * readiness.mastery))
                }
            }
            .frame(height: 7)

            HStack(spacing: 4) {
                Text("\(Int(readiness.domain.examWeight * 100))% of exam")
                Text("·")
                Text(readiness.attempts == 0
                     ? "no questions yet"
                     : "\(readiness.correct)/\(readiness.attempts) correct")
            }
            .font(.caption2)
            .foregroundStyle(Color.brandSlate)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(readiness.domain.rawValue)
        .accessibilityValue(
            readiness.isUnderEvidenced
            ? "Not enough data. \(readiness.attempts) answered."
            : "\(Int((readiness.mastery * 100).rounded())) percent mastery, \(readiness.correct) of \(readiness.attempts) correct."
        )
    }
}

/// A compact labelled statistic.
struct StatTile: View {
    let value: String
    let label: String
    var systemImage: String?
    var tint: Color = .brandPrimary

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.caption)
                    .foregroundStyle(tint)
            }
            Text(value)
                .font(.title3.weight(.bold))
                .monospacedDigit()
                .foregroundStyle(Color.primary)
            Text(label)
                .font(.caption2)
                .foregroundStyle(Color.brandSlate)
                .lineLimit(2, reservesSpace: true)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.brandSurface, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(label)
        .accessibilityValue(value)
    }
}

/// The three inputs to the Readiness Score, each shown as a small meter so the learner
/// can see which one is holding the number down.
struct CompositeBreakdownView: View {
    let breakdown: ReadinessBreakdown

    private var rows: [(String, Double, LimitingFactor)] {
        [("Accuracy", breakdown.mastery, .mastery),
         ("Volume", breakdown.coverage, .coverage),
         ("Consistency", breakdown.consistency, .consistency)]
    }

    var body: some View {
        VStack(spacing: 12) {
            ForEach(rows, id: \.0) { label, value, factor in
                HStack(spacing: 10) {
                    Text(label)
                        .font(.subheadline)
                        .foregroundStyle(Color.primary)
                        .frame(width: 92, alignment: .leading)

                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color.brandGraphite.opacity(0.10))
                            Capsule()
                                .fill(factor == breakdown.limitingFactor
                                      ? AnyShapeStyle(LinearGradient.ember)
                                      : AnyShapeStyle(Color.brandSlate.opacity(0.45)))
                                .frame(width: max(3, geo.size.width * value))
                        }
                    }
                    .frame(height: 7)

                    Text("\(Int((value * 100).rounded()))%")
                        .font(.caption.weight(.medium))
                        .monospacedDigit()
                        .foregroundStyle(Color.brandSlate)
                        .frame(width: 40, alignment: .trailing)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel(label)
                .accessibilityValue("\(Int((value * 100).rounded())) percent")
            }
        }
    }
}

/// Empty-state placeholder used where a screen has nothing to show yet.
struct EmptyStateView: View {
    let systemImage: String
    let title: String
    let message: String
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 38, weight: .light))
                .foregroundStyle(Color.brandSlate.opacity(0.7))
            Text(title)
                .font(.headline)
                .foregroundStyle(Color.primary)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(Color.brandSlate)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .buttonStyle(ForgeButtonStyle())
                    .padding(.top, 4)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .padding(.horizontal, 24)
    }
}

/// The app's primary button: ember fill, rounded, full width where placed in a stack.
struct ForgeButtonStyle: ButtonStyle {
    var prominent = true

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(prominent ? Color.white : Color.brandPrimary)
            .padding(.vertical, 14)
            .padding(.horizontal, 22)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(prominent
                          ? AnyShapeStyle(LinearGradient.ember)
                          : AnyShapeStyle(Color.brandPrimary.opacity(0.12)))
            }
            .opacity(configuration.isPressed ? 0.82 : 1)
            .scaleEffect(configuration.isPressed ? 0.985 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

/// Formatting helpers used in more than one screen.
enum Format {
    /// "2h 14m", "14m", "—"
    static func duration(_ interval: TimeInterval) -> String {
        guard interval >= 60 else { return interval > 0 ? "<1m" : "—" }
        let minutes = Int(interval / 60)
        let hours = minutes / 60
        let remainder = minutes % 60
        return hours > 0 ? "\(hours)h \(remainder)m" : "\(minutes)m"
    }

    static func percent(_ value: Double) -> String {
        "\(Int((value * 100).rounded()))%"
    }

    static let shortDate: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MMM d"
        return f
    }()
}
