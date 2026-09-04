import SwiftUI

/// The shared reading surface behind Feed and Favorites, so both screens stay
/// visually identical.
struct PostList: View {
    let posts: [Post]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(posts) { post in
                    PostView(post: post)

                    if post.id != posts.last?.id {
                        Divider()
                            .padding(.horizontal, 24)
                    }
                }
            }
            .padding(.bottom, 24)
            .animation(.smooth(duration: 0.3), value: posts.count)
        }
        .scrollIndicators(.hidden)
    }
}
