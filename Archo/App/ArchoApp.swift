import SwiftData
import SwiftUI

@main
struct ArchoApp: App {
    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
        .modelContainer(for: Post.self)
    }
}
