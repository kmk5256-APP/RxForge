import SwiftUI

struct ContentView: View {
    @Environment(ProgressManager.self) private var progressManager
    @State private var selectedTab = 0
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        Group {
            if hasCompletedOnboarding {
                TabView(selection: $selectedTab) {
                    HomeView()
                        .tabItem {
                            Label("Home", systemImage: "house.fill")
                        }
                        .tag(0)
                    
                    PracticeHomeView()
                        .tabItem {
                            Label("Practice", systemImage: "flask.fill")
                        }
                        .tag(1)
                    
                    ProgressDashboard()
                        .tabItem {
                            Label("Progress", systemImage: "chart.line.uptrend.xyaxis")
                        }
                        .tag(2)
                    
                    TopicsView()
                        .tabItem {
                            Label("Topics", systemImage: "books.vertical.fill")
                        }
                        .tag(3)
                }
                .tint(Color.brandPrimary)
            } else {
                OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(ProgressManager())
}
