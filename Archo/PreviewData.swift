import Foundation
import SwiftData

/// In-memory sample data so the SwiftUI previews have something to render.
enum PreviewData {
    @MainActor
    static func container(includePosts: Bool = true) -> ModelContainer {
        let container = try! ModelContainer(
            for: Post.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )

        guard includePosts else { return container }

        let samples: [(String, Topic, Bool)] = [
            ("The best ideas arrive once you stop trying to force them.", .reflection, true),
            (
                "Consistency is quieter than intensity, and it outlasts it. Choose the version of the work you can repeat on an ordinary day.",
                .discipline,
                false
            ),
            ("You have handled uncertain days before this one.", .confidence, true),
            ("Meaning is something you practice, not only something you find.", .philosophy, false),
        ]

        for (index, sample) in samples.enumerated() {
            container.mainContext.insert(
                Post(
                    text: sample.0,
                    category: sample.1.rawValue,
                    createdAt: .now.addingTimeInterval(TimeInterval(-index * 5400)),
                    isFavorite: sample.2
                )
            )
        }

        return container
    }

    @MainActor
    static func posts(in container: ModelContainer) -> [Post] {
        (try? container.mainContext.fetch(FetchDescriptor<Post>())) ?? []
    }
}
