import Foundation
import SwiftData

/// A single generated thought. Posts are independent: nothing records which
/// generation call produced them.
@Model
final class Post {
    var id: UUID
    var text: String
    var createdAt: Date
    var category: String
    var isFavorite: Bool

    init(
        id: UUID = UUID(),
        text: String,
        category: String,
        createdAt: Date = .now,
        isFavorite: Bool = false
    ) {
        self.id = id
        self.text = text
        self.category = category
        self.createdAt = createdAt
        self.isFavorite = isFavorite
    }
}
