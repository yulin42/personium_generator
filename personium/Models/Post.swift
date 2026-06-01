//
//  Post.swift
//  personium
//

import Foundation

struct Post: Identifiable, Equatable, Hashable {
    let id: UUID
    var text: String
    let createdAt: Date
    var isFavorite: Bool

    init(
        id: UUID = UUID(),
        text: String,
        createdAt: Date = Date(),
        isFavorite: Bool = false
    ) {
        self.id = id
        self.text = text
        self.createdAt = createdAt
        self.isFavorite = isFavorite
    }
}
