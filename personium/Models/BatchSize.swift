//
//  BatchSize.swift
//  personium
//

import Foundation

enum BatchSize: Int, CaseIterable, Identifiable, Hashable {
    case ten = 10
    case twenty = 20
    case thirty = 30
    case fifty = 50

    var id: Int { rawValue }

    var label: String { "\(rawValue)" }
}
