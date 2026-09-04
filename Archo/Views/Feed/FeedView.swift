import SwiftData
import SwiftUI

struct FeedView: View {
    @Query(sort: \Post.createdAt, order: .reverse) private var posts: [Post]

    /// Sends the user to the Generate tab from the empty state.
    var onGenerate: () -> Void

    var body: some View {
        Group {
            if posts.isEmpty {
                EmptyStateView(
                    title: "Nothing here yet.",
                    message: "Generate your first thoughts.",
                    actionTitle: "Generate Posts",
                    action: onGenerate
                )
            } else {
                PostList(posts: posts)
            }
        }
        .navigationTitle("Archo")
    }
}

#Preview("Feed") {
    NavigationStack {
        FeedView(onGenerate: {})
    }
    .modelContainer(PreviewData.container())
}

#Preview("Empty") {
    NavigationStack {
        FeedView(onGenerate: {})
    }
    .modelContainer(PreviewData.container(includePosts: false))
}
