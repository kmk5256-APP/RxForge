import SwiftUI

/// The Readiness Score, drawn as an open-bottom arc with its confidence band shown as a
/// lighter sweep behind the value.
///
/// The band is not decoration: showing it is what keeps the score honest when the
/// learner has only answered a handful of questions.
struct ReadinessDial: View {
    let breakdown: ReadinessBreakdown
    var diameter: CGFloat = 208
    var showsBand = true

    /// Fraction of the circle the arc spans (270° of 360°).
    private let sweep = 0.75
    private var lineWidth: CGFloat { diameter * 0.085 }

    @State private var animatedFraction: Double = 0

    private var fraction: Double { Double(breakdown.score) / 100 }
    private var lowFraction: Double { Double(breakdown.confidenceLow) / 100 }
    private var highFraction: Double { Double(breakdown.confidenceHigh) / 100 }

    var body: some View {
        ZStack {
            // Track
            DialArc(from: 0, to: 1, sweep: sweep)
                .stroke(Color.brandGraphite.opacity(0.14),
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))

            // Confidence band — the range the score plausibly sits in.
            if showsBand && breakdown.totalAttempts > 0 {
                DialArc(from: lowFraction, to: highFraction, sweep: sweep)
                    .stroke(Color.brandPrimary.opacity(0.22),
                            style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            }

            // Value
            DialArc(from: 0, to: animatedFraction, sweep: sweep)
                .stroke(LinearGradient.ember,
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))

            VStack(spacing: 2) {
                Text("\(breakdown.score)")
                    .font(.system(size: diameter * 0.29, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .contentTransition(.numericText())
                    .foregroundStyle(Color.primary)

                Text("Readiness")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .textCase(.uppercase)
                    .kerning(0.8)
                    .foregroundStyle(Color.brandSlate)

                if breakdown.totalAttempts > 0 {
                    Text("± \(breakdown.confidenceHalfWidth)")
                        .font(.caption2)
                        .monospacedDigit()
                        .foregroundStyle(Color.brandSlate.opacity(0.8))
                        .padding(.top, 2)
                }
            }
            .offset(y: -diameter * 0.02)
        }
        .frame(width: diameter, height: diameter)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Readiness score")
        .accessibilityValue(
            breakdown.totalAttempts > 0
            ? "\(breakdown.score) out of 100, plus or minus \(breakdown.confidenceHalfWidth). \(breakdown.band)."
            : "No score yet. Answer questions to build one."
        )
        .onAppear {
            withAnimation(.easeOut(duration: 0.9)) { animatedFraction = fraction }
        }
        .onChange(of: breakdown.score) { _, _ in
            withAnimation(.easeOut(duration: 0.6)) { animatedFraction = fraction }
        }
    }
}

/// An arc of `sweep` fraction of a circle, centred at the bottom gap, drawn from
/// `from` to `to` where both are 0...1 along that sweep.
private struct DialArc: Shape {
    var from: Double
    var to: Double
    var sweep: Double

    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(from, to) }
        set { from = newValue.first; to = newValue.second }
    }

    func path(in rect: CGRect) -> Path {
        let radius = min(rect.width, rect.height) / 2
        let centre = CGPoint(x: rect.midX, y: rect.midY)

        // Centre the gap at the bottom: start at 135° and sweep clockwise.
        let startAngle = 90.0 + (1 - sweep) * 180.0
        let total = sweep * 360.0

        var path = Path()
        path.addArc(center: centre,
                    radius: radius,
                    startAngle: .degrees(startAngle + total * min(from, to)),
                    endAngle: .degrees(startAngle + total * max(from, to)),
                    clockwise: false)
        return path
    }
}

#Preview("With evidence") {
    ReadinessDial(breakdown: ReadinessEngine.evaluate(
        evidence: [
            DomainEvidence(domain: .foundational, attempts: 40, correct: 30, lastAnswered: Date()),
            DomainEvidence(domain: .medicationUse, attempts: 35, correct: 22, lastAnswered: Date()),
            DomainEvidence(domain: .assessmentPlanning, attempts: 60, correct: 41, lastAnswered: Date()),
            DomainEvidence(domain: .professionalPractice, attempts: 8, correct: 6, lastAnswered: Date()),
            DomainEvidence(domain: .managementLeadership, attempts: 6, correct: 3, lastAnswered: Date()),
        ],
        studyDays: Set((0..<9).compactMap {
            Calendar.current.date(byAdding: .day, value: -$0, to: Calendar.current.startOfDay(for: Date()))
        })
    ))
    .padding()
}

#Preview("Empty") {
    ReadinessDial(breakdown: .empty).padding()
}
