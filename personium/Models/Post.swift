//
//  Post.swift
//  personium
//

import Foundation
import SwiftData

@Model
final class Post {
    var id: UUID
    var text: String
    var createdAt: Date
    var isFavorite: Bool

    var batch: Batch?

    init(
        id: UUID = UUID(),
        text: String,
        createdAt: Date = .now,
        isFavorite: Bool = false,
        batch: Batch? = nil
    ) {
        self.id = id
        self.text = text
        self.createdAt = createdAt
        self.isFavorite = isFavorite
        self.batch = batch
    }
}
