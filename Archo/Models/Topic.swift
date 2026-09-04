import Foundation

/// The subjects a user can generate posts about. The raw value is what gets
/// stored in `Post.category` and sent to the generation service.
enum Topic: String, CaseIterable, Identifiable, Hashable {
    case reflection = "Reflection"
    case motivation = "Motivation"
    case discipline = "Discipline"
    case focus = "Focus"
    case confidence = "Confidence"
    case philosophy = "Philosophy"

    var id: String { rawValue }
}
