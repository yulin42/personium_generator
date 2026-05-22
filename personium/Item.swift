//
//  Item.swift
//  personium
//
//  Created by Yulin Feng on 2026-05-22.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
