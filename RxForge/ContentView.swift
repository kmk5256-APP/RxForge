import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(ProgressManager.self) private var progressManager
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab = 0
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    #if DEBUG
    @State private var harnessSession: QuizSession?
    #endif

    var body: some View {
        Group {
            if hasCompletedOnboarding || harnessActive {
                TabView(selection: $selectedTab) {
                    HomeView()
                        .tabItem { Label("Home", systemImage: "house.fill") }
                        .tag(0)

                    PracticeHomeView()
                        .tabItem { Label("Practice", systemImage: "flask.fill") }
                        .tag(1)

                    ProgressDashboard()
                        .tabItem { Label("Progress", systemImage: "chart.line.uptrend.xyaxis") }
                        .tag(2)

                    TopicsView()
                        .tabItem { Label("Blueprint", systemImage: "books.vertical.fill") }
                        .tag(3)
                }
                .tint(Color.brandPrimary)
            } else {
                OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
            }
        }
        .task { applyHarness() }
        #if DEBUG
        .fullScreenCover(item: $harnessSession) { session in
            QuizView(session: session)
        }
        #endif
    }

    private var harnessActive: Bool {
        #if DEBUG
        return DebugHarness.isActive
        #else
        return false
        #endif
    }

    /// All debug-harness setup happens here, in order, *after* configuring the manager.
    ///
    /// `configure(with:)` is idempotent, so calling it here as well as from `RxForgeApp`
    /// is harmless — and it removes the race that previously let seeding and
    /// auto-answering run against a nil model context, silently discarding every record.
    private func applyHarness() {
        #if DEBUG
        progressManager.configure(with: modelContext)

        guard DebugHarness.isActive else { return }

        if DebugHarness.isFresh { progressManager.resetAllProgress() }

        if DebugHarness.isSeeding, progressManager.readiness.totalAttempts == 0 {
            DebugHarness.seed(into: progressManager)
        }

        if let tab = DebugHarness.requestedTab { selectedTab = tab }

        if let mode = DebugHarness.requestedQuiz, harnessSession == nil {
            let candidate = QuizSession.make(mode: mode, progressManager: progressManager)
            if !candidate.isEmpty {
                if let n = DebugHarness.autoAnswerCount {
                    DebugHarness.autoAnswer(candidate, count: n, manager: progressManager)
                }
                harnessSession = candidate
            }
        }
        #endif
    }
}

#Preview {
    ContentView().environment(ProgressManager())
}
