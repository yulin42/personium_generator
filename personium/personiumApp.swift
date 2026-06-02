//
//  personiumApp.swift
//  personium
//
//  Created by Yulin Feng on 2026-05-22.
//

import SwiftData
import SwiftUI

@main
struct personiumApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Post.self,
            Batch.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(sharedModelContainer)
    }
}
