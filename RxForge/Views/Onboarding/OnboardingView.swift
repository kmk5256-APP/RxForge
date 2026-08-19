import SwiftUI

/// Three panes: what the app is, what the score means, and an optional exam date.
/// Kept short deliberately — the PRD's success criterion is a first Readiness Score in
/// under five minutes, and onboarding is not where that time should go.
struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @Environment(ProgressManager.self) private var progressManager

    @State private var page = 0
    @State private var wantsExamDate = false
    @State private var examDate = Calendar.current.date(byAdding: .month, value: 2, to: Date()) ?? Date()

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $page) {
                intro.tag(0)
                scoreExplainer.tag(1)
                examDatePane.tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))

            VStack(spacing: 10) {
                Button(page == 2 ? "Start studying" : "Continue") {
                    if page < 2 {
                        withAnimation { page += 1 }
                    } else {
                        complete()
                    }
                }
                .buttonStyle(ForgeButtonStyle())

                if page < 2 {
                    Button("Skip") { complete() }
                        .font(.subheadline)
                        .foregroundStyle(Color.brandSlate)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
            .padding(.top, 8)
        }
        .background(Color.brandBackground)
    }

    // MARK: - Panes

    private var intro: some View {
        pane {
            ZStack {
                Circle()
                    .fill(LinearGradient.ember)
                    .frame(width: 96, height: 96)
                    .opacity(0.16)
                Image(systemName: "hammer.fill")
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundStyle(LinearGradient.ember)
            }

            Text("RxForge")
                .font(.largeTitle.weight(.bold))

            Text("A NAPLEX readiness check, not another question bank.")
                .font(.title3)
                .foregroundStyle(Color.brandSlate)
                .multilineTextAlignment(.center)

            Text("Built on the NAPLEX Content Outline that took effect May 1, 2025 — five content domains, weighted the way the exam weights them.")
                .font(.subheadline)
                .foregroundStyle(Color.brandSlate)
                .multilineTextAlignment(.center)
                .padding(.top, 2)
        }
    }

    private var scoreExplainer: some View {
        pane {
            Text("Your Readiness Score")
                .font(.title.weight(.bold))
                .multilineTextAlignment(.center)

            Text("One number from three things:")
                .font(.subheadline)
                .foregroundStyle(Color.brandSlate)

            VStack(alignment: .leading, spacing: 14) {
                explainerRow("target", "Accuracy",
                             "Weighted by how much each domain counts on the exam.")
                explainerRow("square.stack.3d.up", "Volume",
                             "Five questions right isn't mastery. The score stays cautious until you've answered enough.")
                explainerRow("calendar", "Consistency",
                             "A strong week last month isn't readiness today.")
            }
            .padding(.top, 4)

            Text("It is a study-progress score — not a predicted exam result.")
                .font(.caption)
                .foregroundStyle(Color.brandSlate)
                .multilineTextAlignment(.center)
                .padding(.top, 6)
        }
    }

    private var examDatePane: some View {
        pane {
            Image(systemName: "calendar.badge.clock")
                .font(.system(size: 40, weight: .light))
                .foregroundStyle(LinearGradient.ember)

            Text("When's your exam?")
                .font(.title.weight(.bold))

            Text("Optional. It adds a countdown and a daily pace to your home screen.")
                .font(.subheadline)
                .foregroundStyle(Color.brandSlate)
                .multilineTextAlignment(.center)

            Toggle("Set an exam date", isOn: $wantsExamDate.animation())
                .tint(.brandPrimary)
                .padding(.top, 6)

            if wantsExamDate {
                DatePicker("Exam date", selection: $examDate,
                           in: Date()..., displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .tint(.brandPrimary)
            }
        }
    }

    // MARK: - Pieces

    private func pane<C: View>(@ViewBuilder _ content: () -> C) -> some View {
        VStack(spacing: 14) {
            Spacer(minLength: 20)
            content()
            Spacer(minLength: 40)
        }
        .padding(.horizontal, 30)
    }

    private func explainerRow(_ symbol: String, _ title: String, _ detail: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: symbol)
                .font(.body)
                .foregroundStyle(Color.brandPrimary)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.subheadline.weight(.semibold))
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(Color.brandSlate)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private func complete() {
        if wantsExamDate { progressManager.examDate = examDate }
        withAnimation { hasCompletedOnboarding = true }
    }
}

#Preview {
    OnboardingView(hasCompletedOnboarding: .constant(false))
        .environment(ProgressManager())
}
