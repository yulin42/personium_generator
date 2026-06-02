//
//  GenerateCategory.swift
//  personium
//

import Foundation

enum GenerateCategory: String, CaseIterable, Identifiable, Hashable, Codable {
    case reflection = "Reflection"
    case motivation = "Motivation"
    case discipline = "Discipline"
    case focus = "Focus"
    case confidence = "Confidence"
    case philosophy = "Philosophy"

    var id: String { rawValue }

    var displayName: String { rawValue }
}
