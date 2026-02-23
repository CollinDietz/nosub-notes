import SwiftUI
import SwiftData

@main
struct nosub_notesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Note.self, NotePage.self])
    }
}
