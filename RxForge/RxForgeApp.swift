import SwiftUI
import SwiftData

@main
struct RxForgeApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserProgress.self,
            StudySession.self,
            AnswerRecord.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @State private var progressManager = ProgressManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(progressManager)
                .tint(.brandPrimary)
                .onAppear {
                    progressManager.configure(with: sharedModelContainer.mainContext)
                    #if DEBUG
                    // Debug-harness seeding lives in ContentView.applyHarness, which
                    // configures the manager itself first — keeping it in one ordered
                    // place rather than split across two lifecycle callbacks that race.
                    let problems = QuestionBank.validate()
                    if problems.isEmpty {
                        print("[RxForge] Question bank OK — \(QuestionBank.all.count) questions.")
                        for domain in Domain.allCases {
                            print("[RxForge]   \(domain.number). \(domain.shortName): \(QuestionBank.count(for: domain)) (blueprint \(Int(domain.examWeight * 100))%)")
                        }
                    } else {
                        print("[RxForge] QUESTION BANK PROBLEMS:")
                        problems.forEach { print("[RxForge]   - \($0)") }
                        assertionFailure("Question bank failed validation; see console.")
                    }
                    #endif
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
