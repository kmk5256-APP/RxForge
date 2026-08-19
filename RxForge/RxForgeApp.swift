import SwiftUI
import SwiftData

@main
struct RxForgeApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserProgress.self,
            StudySession.self
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
                .onAppear {
                    progressManager.configure(with: sharedModelContainer.mainContext)
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
