//
//  PreviewSampleData.swift
//  personium
//

import Foundation
import SwiftData

enum PreviewSampleData {
    @MainActor
    static func makeContainer(includePosts: Bool = true) -> ModelContainer {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(
            for: Post.self, Batch.self,
            configurations: configuration
        )

        guard includePosts else { return container }

        let context = container.mainContext
        let batch = Batch(category: GenerateCategory.reflection.rawValue, size: 3)
        context.insert(batch)

        let samples: [(String, Bool)] = [
            ("The best ideas often arrive when you stop trying to force them.", true),
            ("A longer thought can still belong in a feed without feeling cramped.", false),
            ("Small notes add up.", false),
        ]

        for (index, sample) in samples.enumerated() {
            let post = Post(
                text: sample.0,
                createdAt: .now.addingTimeInterval(TimeInterval(-index * 3600)),
                isFavorite: sample.1,
                batch: batch
            )
            batch.posts.append(post)
            context.insert(post)
        }

        try? context.save()
        return container
    }
}
