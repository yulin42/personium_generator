//
//  FeedViewModel.swift
//  personium
//

import Foundation
import Observation

@Observable
@MainActor
final class FeedViewModel {
    private let postService: PostService

    init(postService: PostService) {
        self.postService = postService
    }

    func toggleFavorite(_ post: Post) {
        postService.toggleFavorite(post)
    }
}
