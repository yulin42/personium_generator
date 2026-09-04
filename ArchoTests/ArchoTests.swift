import Foundation
import SwiftData
import Testing
@testable import Archo

struct GenerationErrorTests {
    @Test func missingKeyIsReportedBeforeAnyRequest() async throws {
        let service = OpenAIService(apiKey: nil)

        await #expect(throws: GenerationError.missingAPIKey) {
            try await service.generatePosts(category: "Focus", count: 10)
        }
    }

    @Test func everyErrorHasAUserFacingMessage() {
        for error in [GenerationError.missingAPIKey, .offline, .failed] {
            #expect(error.errorDescription?.isEmpty == false)
        }
    }
}

struct ResponseDecodingTests {
    private func completion(posts: [String]) -> Data {
        let payload = try! JSONSerialization.data(withJSONObject: ["posts": posts])
        let content = String(decoding: payload, as: UTF8.self)
        let body = ["choices": [["message": ["content": content]]]]
        return try! JSONSerialization.data(withJSONObject: body)
    }

    @Test func decodesPosts() {
        let data = completion(posts: ["One quiet thought.", "Another one."])

        #expect(OpenAIService.decodePosts(from: data) == ["One quiet thought.", "Another one."])
    }

    @Test func stripsListMarkersAndWrappingQuotes() {
        let data = completion(posts: ["- A bulleted thought.", "2. A numbered thought.", "\"A quoted thought.\""])

        #expect(
            OpenAIService.decodePosts(from: data) == [
                "A bulleted thought.",
                "A numbered thought.",
                "A quoted thought.",
            ]
        )
    }

    @Test func dropsDuplicatesAndBlanks() {
        let data = completion(posts: ["Same thought.", "same thought.", "  ", ""])

        #expect(OpenAIService.decodePosts(from: data) == ["Same thought."])
    }

    @Test func returnsNothingForEmptyOrInvalidResponses() {
        #expect(OpenAIService.decodePosts(from: completion(posts: [])).isEmpty)
        #expect(OpenAIService.decodePosts(from: Data("not json".utf8)).isEmpty)

        let unparsableContent = try! JSONSerialization.data(
            withJSONObject: ["choices": [["message": ["content": "sorry, I can't help"]]]]
        )
        #expect(OpenAIService.decodePosts(from: unparsableContent).isEmpty)
    }
}

struct PostTests {
    @Test func newPostsAreNotFavorited() {
        let post = Post(text: "A thought.", category: Topic.focus.rawValue)

        #expect(post.isFavorite == false)
        #expect(post.category == "Focus")
    }

    /// Closing and reopening the app must not lose posts or favorites.
    @Test func postsAndFavoritesSurviveAReopen() throws {
        let url = URL.temporaryDirectory.appending(path: "archo-\(UUID().uuidString).store")
        defer { try? FileManager.default.removeItem(at: url) }

        let configuration = ModelConfiguration(url: url)

        do {
            let context = ModelContext(try ModelContainer(for: Post.self, configurations: configuration))
            context.insert(Post(text: "Saved.", category: "Focus", isFavorite: true))
            context.insert(Post(text: "Not saved as a favorite.", category: "Focus"))
            try context.save()
        }

        // Reopen the same store the way a relaunch would.
        let context = ModelContext(try ModelContainer(for: Post.self, configurations: configuration))

        #expect(try context.fetchCount(FetchDescriptor<Post>()) == 2)

        let favorites = try context.fetch(
            FetchDescriptor<Post>(predicate: #Predicate { $0.isFavorite })
        )
        #expect(favorites.map(\.text) == ["Saved."])
    }
}
