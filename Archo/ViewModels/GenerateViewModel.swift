import Foundation
import Observation
import SwiftData

@MainActor
@Observable
final class GenerateViewModel {
    var topic: Topic = .reflection
    var postCount: PostCount = .twenty

    private(set) var isGenerating = false
    private(set) var errorMessage: String?

    private let service: OpenAIService

    init(service: OpenAIService = OpenAIService()) {
        self.service = service
    }

    /// Generates posts and inserts each one as an independent `Post`.
    /// Returns `true` when new posts reached the store.
    @discardableResult
    func generate(into context: ModelContext) async -> Bool {
        guard !isGenerating else { return false }

        isGenerating = true
        errorMessage = nil
        defer { isGenerating = false }

        // Read the selection up front so posts keep the topic the user asked
        // for, even if they change the picker while the request is in flight.
        let category = topic.rawValue

        do {
            let texts = try await service.generatePosts(
                category: category,
                count: postCount.rawValue
            )

            let createdAt = Date()
            for (index, text) in texts.enumerated() {
                context.insert(
                    Post(
                        text: text,
                        category: category,
                        // Spread timestamps so the feed keeps a stable order.
                        createdAt: createdAt.addingTimeInterval(TimeInterval(-index))
                    )
                )
            }

            try context.save()
            return true
        } catch {
            errorMessage = (error as? GenerationError ?? .failed).localizedDescription
            return false
        }
    }

    func dismissError() {
        errorMessage = nil
    }
}
