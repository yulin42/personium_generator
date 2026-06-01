//
//  FavoritesViewModel.swift
//  personium
//

import Foundation
import Observation

@Observable
final class FavoritesViewModel {
    var posts: [Post]

    init(posts: [Post] = []) {
        self.posts = posts
    }

    var favoritePosts: [Post] {
        posts.filter(\.isFavorite)
    }

    func toggleFavorite(for postID: Post.ID) {
        guard let index = posts.firstIndex(where: { $0.id == postID }) else { return }
        posts[index].isFavorite.toggle()
    }
}

extension FavoritesViewModel {
    static let preview = FavoritesViewModel(posts: [
        Post(
            text: "The best ideas often arrive when you stop trying to force them.",
            createdAt: .now.addingTimeInterval(-3600),
            isFavorite: true
        ),
        Post(
            text: "You have handled uncertain days before this one.",
            createdAt: .now.addingTimeInterval(-7200),
            isFavorite: true
        ),
        Post(
            text: "Small notes add up.",
            createdAt: .now.addingTimeInterval(-172_800),
            isFavorite: false
        ),
    ])

    static let empty = FavoritesViewModel(posts: [
        Post(text: "This post is not favorited.", isFavorite: false),
    ])
}
