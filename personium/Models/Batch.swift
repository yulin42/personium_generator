//
//  Batch.swift
//  personium
//

import Foundation
import SwiftData

@Model
final class Batch {
    var id: UUID
    var category: String
    var createdAt: Date
    var size: Int

    @Relationship(deleteRule: .cascade, inverse: \Post.batch)
    var posts: [Post]

    init(
        id: UUID = UUID(),
        category: String,
        createdAt: Date = .now,
        size: Int,
        posts: [Post] = []
    ) {
        self.id = id
        self.category = category
        self.createdAt = createdAt
        self.size = size
        self.posts = posts
    }
}

extension Batch {
    var generateCategory: GenerateCategory? {
        GenerateCategory(rawValue: category)
    }
}
