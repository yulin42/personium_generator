//
//  GenerationService.swift
//  personium
//

import Foundation
import SwiftData

@MainActor
final class GenerationService {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func generate(category: GenerateCategory, count: Int) async throws -> Batch {
        // Placeholder delay until a real generation API is wired up.
        try await Task.sleep(for: .seconds(1.2))

        let batch = Batch(
            category: category.rawValue,
            size: count
        )
        modelContext.insert(batch)

        let templates = Self.sampleTexts(for: category)
        let now = Date()

        for index in 0..<count {
            let post = Post(
                text: templates[index % templates.count],
                createdAt: now.addingTimeInterval(TimeInterval(-index * 3)),
                batch: batch
            )
            batch.posts.append(post)
            modelContext.insert(post)
        }

        try modelContext.save()
        return batch
    }
}

// MARK: - Sample content

private extension GenerationService {
    static func sampleTexts(for category: GenerateCategory) -> [String] {
        switch category {
        case .reflection:
            [
                "Notice what you keep returning to when the room is quiet.",
                "A honest pause can change the tone of an entire day.",
                "Ask yourself what you are protecting, and why.",
            ]
        case .motivation:
            [
                "Start before you feel ready; readiness often follows action.",
                "Momentum is built in small, repeated choices.",
                "Your future self is shaped by what you do next.",
            ]
        case .discipline:
            [
                "Consistency beats intensity when the goal is lasting change.",
                "Do the next right thing, even when it is small.",
                "Structure is kindness to your future focus.",
            ]
        case .focus:
            [
                "One task, fully seen, is enough for this moment.",
                "Protect your attention like something scarce and valuable.",
                "Clarity grows when distractions lose their invitation.",
            ]
        case .confidence:
            [
                "You have handled uncertain days before this one.",
                "Speak to yourself the way you would to someone you respect.",
                "Courage is often quiet and repeated, not loud and rare.",
            ]
        case .philosophy:
            [
                "Meaning is something you practice, not only something you find.",
                "What you attend to becomes, in part, who you are.",
                "A good question can outlast a quick answer.",
            ]
        }
    }
}
