//
//  AppDependencies.swift
//  personium
//

import SwiftData
import SwiftUI

@MainActor
final class AppDependencies {
    let postService: PostService
    let generationService: GenerationService

    init(modelContext: ModelContext) {
        postService = PostService(modelContext: modelContext)
        generationService = GenerationService(modelContext: modelContext)
    }
}

private struct AppDependenciesKey: EnvironmentKey {
    static let defaultValue: AppDependencies? = nil
}

extension EnvironmentValues {
    var appDependencies: AppDependencies? {
        get { self[AppDependenciesKey.self] }
        set { self[AppDependenciesKey.self] = newValue }
    }
}
