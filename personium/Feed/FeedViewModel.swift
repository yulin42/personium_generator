//
//  FeedViewModel.swift
//  personium
//

import Foundation
import Observation

@Observable
final class FeedViewModel {
    var posts: [Post]

    init(posts: [Post] = []) {
        self.posts = posts
    }

    func toggleFavorite(for postID: Post.ID) {
        guard let index = posts.firstIndex(where: { $0.id == postID }) else { return }
        posts[index].isFavorite.toggle()
    }
}

extension FeedViewModel {
    static let preview = FeedViewModel(posts: [
        Post(
            text: "The best ideas often arrive when you stop trying to force them.",
            createdAt: .now.addingTimeInterval(-3600),
            isFavorite: true
        ),
        Post(
            text: """
            A longer thought can still belong in a feed: write freely, \
            let the card grow with the text, and trust that comfortable \
            spacing and readable type will carry it without feeling cramped.
            """,
            createdAt: .now.addingTimeInterval(-86_400)
        ),
        Post(
            text: "Small notes add up.",
            createdAt: .now.addingTimeInterval(-172_800)
        ),
    ])

    static let empty = FeedViewModel(posts: [])
}
