//
//  FavoritesView.swift
//  personium
//

import SwiftData
import SwiftUI

struct FavoritesView: View {
    @Environment(\.appDependencies) private var dependencies
    @Query(
        filter: #Predicate<Post> { $0.isFavorite },
        sort: \Post.createdAt,
        order: .reverse
    ) private var favoritePosts: [Post]

    @State private var viewModel: FavoritesViewModel?

    var body: some View {
        Group {
            if favoritePosts.isEmpty {
                emptyState
            } else {
                favoritesList
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.large)
        .onAppear(perform: configureViewModelIfNeeded)
    }

    private var favoritesList: some View {
        ScrollView {
            LazyVStack(spacing: 28) {
                ForEach(favoritePosts) { post in
                    PostCard(post: post) {
                        viewModel?.toggleFavorite(post)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
        }
        .scrollIndicators(.hidden)
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Text("No favorites yet")
                .font(.title2.weight(.semibold))
                .foregroundStyle(.primary)

            Text("Save posts you want to revisit.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func configureViewModelIfNeeded() {
        guard viewModel == nil, let dependencies else { return }
        viewModel = FavoritesViewModel(postService: dependencies.postService)
    }
}

#Preview("Favorites") {
    let container = PreviewSampleData.makeContainer()
    let dependencies = AppDependencies(modelContext: container.mainContext)

    return NavigationStack {
        FavoritesView()
            .environment(\.appDependencies, dependencies)
    }
    .modelContainer(container)
}

#Preview("Empty") {
    let container = PreviewSampleData.makeContainer(includePosts: false)
    let dependencies = AppDependencies(modelContext: container.mainContext)

    return NavigationStack {
        FavoritesView()
            .environment(\.appDependencies, dependencies)
    }
    .modelContainer(container)
}
