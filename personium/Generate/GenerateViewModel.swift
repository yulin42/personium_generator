//
//  GenerateViewModel.swift
//  personium
//

import Foundation
import Observation

@Observable
final class GenerateViewModel {
    var selectedCategory: GenerateCategory = .reflection
    var selectedBatchSize: BatchSize = .ten
    var isGenerating = false

    func generate() async -> [Post] {
        guard !isGenerating else { return [] }

        isGenerating = true
        defer { isGenerating = false }

        // Placeholder delay until a real generation service is wired up.
        try? await Task.sleep(for: .seconds(1.2))

        return Self.makePosts(category: selectedCategory, count: selectedBatchSize.rawValue)
    }
}

// MARK: - Mock generation

private extension GenerateViewModel {
    static func makePosts(category: GenerateCategory, count: Int) -> [Post] {
        let templates = sampleTexts(for: category)
        let now = Date()

        return (0..<count).map { index in
            Post(
                text: templates[index % templates.count],
                createdAt: now.addingTimeInterval(TimeInterval(-index * 3))
            )
        }
    }

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

extension GenerateViewModel {
    static let preview = GenerateViewModel()

    static var loadingPreview: GenerateViewModel {
        let viewModel = GenerateViewModel()
        viewModel.isGenerating = true
        return viewModel
    }
}
