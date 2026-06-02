//
//  PostService.swift
//  personium
//

import Foundation
import SwiftData

@MainActor
final class PostService {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func toggleFavorite(_ post: Post) {
        post.isFavorite.toggle()
        save()
    }

    private func save() {
        do {
            try modelContext.save()
        } catch {
            assertionFailure("Failed to save post changes: \(error)")
        }
    }
}
