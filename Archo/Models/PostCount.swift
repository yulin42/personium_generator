import Foundation

/// How many posts a single generation produces.
enum PostCount: Int, CaseIterable, Identifiable, Hashable {
    case ten = 10
    case twenty = 20
    case thirty = 30
    case fifty = 50

    var id: Int { rawValue }

    var label: String { "\(rawValue)" }
}
