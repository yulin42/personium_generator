import SwiftData
import SwiftUI

/// A single post as it appears in Feed and Favorites: the text carries the
/// screen, everything else stays quiet underneath it.
struct PostView: View {
    @Environment(\.modelContext) private var modelContext

    let post: Post

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(post.text)
                .font(.system(.title3, design: .serif))
                .lineSpacing(7)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .textSelection(.enabled)

            HStack(alignment: .center, spacing: 8) {
                metadata
                Spacer(minLength: 12)
                favoriteButton
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 28)
    }

    private var metadata: some View {
        HStack(spacing: 8) {
            Text(post.category.uppercased())
                .tracking(1.1)

            Text("·")

            Text(post.createdAt, format: .relative(presentation: .named))
        }
        .font(.caption2)
        .foregroundStyle(.tertiary)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(post.category), \(post.createdAt.formatted(.relative(presentation: .named)))")
    }

    private var favoriteButton: some View {
        Button {
            withAnimation(.snappy(duration: 0.25, extraBounce: 0.25)) {
                post.isFavorite.toggle()
            }
            // Don't wait for autosave: favorites must survive a hard quit.
            try? modelContext.save()
        } label: {
            Image(systemName: post.isFavorite ? "heart.fill" : "heart")
                .font(.body.weight(.medium))
                .foregroundStyle(post.isFavorite ? Color.accentColor : Color.secondary)
                .contentTransition(.symbolEffect(.replace))
                .frame(minWidth: 44, minHeight: 44, alignment: .trailing)
                .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.impact(weight: .light), trigger: post.isFavorite)
        .accessibilityLabel(post.isFavorite ? "Remove from favorites" : "Add to favorites")
    }
}

#Preview {
    let container = PreviewData.container()

    return PostList(posts: PreviewData.posts(in: container))
        .modelContainer(container)
}
