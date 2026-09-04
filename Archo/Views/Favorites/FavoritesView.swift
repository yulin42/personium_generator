import SwiftData
import SwiftUI

struct FavoritesView: View {
    @Query(
        filter: #Predicate<Post> { $0.isFavorite },
        sort: \Post.createdAt,
        order: .reverse
    ) private var posts: [Post]

    var body: some View {
        Group {
            if posts.isEmpty {
                EmptyStateView(
                    title: "No favorites yet.",
                    message: "Save posts you want to revisit."
                )
            } else {
                PostList(posts: posts)
            }
        }
        .navigationTitle("Favorites")
    }
}

#Preview("Favorites") {
    NavigationStack {
        FavoritesView()
    }
    .modelContainer(PreviewData.container())
}

#Preview("Empty") {
    NavigationStack {
        FavoritesView()
    }
    .modelContainer(PreviewData.container(includePosts: false))
}
