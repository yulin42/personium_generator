//
//  FeedView.swift
//  personium
//

import SwiftData
import SwiftUI

struct FeedView: View {
    @Environment(\.appDependencies) private var dependencies
    @Query(sort: \Post.createdAt, order: .reverse) private var posts: [Post]

    @State private var viewModel: FeedViewModel?

    var body: some View {
        Group {
            if posts.isEmpty {
                emptyState
            } else {
                feedList
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Murmur")
        .navigationBarTitleDisplayMode(.large)
        .onAppear(perform: configureViewModelIfNeeded)
    }

    private var feedList: some View {
        ScrollView {
            LazyVStack(spacing: 28) {
                ForEach(posts) { post in
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
            Text("No posts yet")
                .font(.title2.weight(.semibold))
                .foregroundStyle(.primary)

            Text("Generate your first batch of thoughts.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func configureViewModelIfNeeded() {
        guard viewModel == nil, let dependencies else { return }
        viewModel = FeedViewModel(postService: dependencies.postService)
    }
}

#Preview("Feed") {
    let container = PreviewSampleData.makeContainer()
    let dependencies = AppDependencies(modelContext: container.mainContext)

    return NavigationStack {
        FeedView()
            .environment(\.appDependencies, dependencies)
    }
    .modelContainer(container)
}

#Preview("Empty") {
    let container = PreviewSampleData.makeContainer(includePosts: false)
    let dependencies = AppDependencies(modelContext: container.mainContext)

    return NavigationStack {
        FeedView()
            .environment(\.appDependencies, dependencies)
    }
    .modelContainer(container)
}
