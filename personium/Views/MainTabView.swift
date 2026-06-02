//
//  MainTabView.swift
//  personium
//

import SwiftData
import SwiftUI

struct MainTabView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var dependencies: AppDependencies?

    var body: some View {
        Group {
            if let dependencies {
                tabView(dependencies: dependencies)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            if dependencies == nil {
                dependencies = AppDependencies(modelContext: modelContext)
            }
        }
    }

    @ViewBuilder
    private func tabView(dependencies: AppDependencies) -> some View {
        TabView {
            NavigationStack {
                FeedView()
            }
            .tabItem {
                Label("Feed", systemImage: "list.bullet")
            }

            NavigationStack {
                GenerateView()
            }
            .tabItem {
                Label("Generate", systemImage: "sparkles")
            }

            NavigationStack {
                FavoritesView()
            }
            .tabItem {
                Label("Favorites", systemImage: "heart")
            }
        }
        .environment(\.appDependencies, dependencies)
    }
}

#Preview {
    let container = PreviewSampleData.makeContainer()

    MainTabView()
        .modelContainer(container)
}
