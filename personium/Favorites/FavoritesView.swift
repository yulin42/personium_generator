//
//  FavoritesView.swift
//  personium
//

import SwiftUI

struct FavoritesView: View {
    @State private var viewModel: FavoritesViewModel

    init(viewModel: FavoritesViewModel = FavoritesViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.favoritePosts.isEmpty {
                    emptyState
                } else {
                    favoritesList
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var favoritesList: some View {
        ScrollView {
            LazyVStack(spacing: 28) {
                ForEach(viewModel.favoritePosts) { post in
                    PostCard(
                        post: post,
                        onFavoriteTap: { viewModel.toggleFavorite(for: post.id) }
                    )
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
}

// MARK: - Previews

#Preview("Favorites") {
    FavoritesView(viewModel: .preview)
}

#Preview("Empty") {
    FavoritesView(viewModel: .empty)
}

#Preview("Dynamic Type") {
    FavoritesView(viewModel: .preview)
        .dynamicTypeSize(.accessibility3)
}
