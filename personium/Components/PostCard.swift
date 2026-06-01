//
//  PostCard.swift
//  personium
//

import SwiftUI

struct PostCard: View {
    let post: Post
    let onFavoriteTap: () -> Void

    @State private var favoriteScale: CGFloat = 1

    private static let createdAtStyle: Date.FormatStyle = .dateTime
        .month(.abbreviated)
        .day()
        .year()
        .hour()
        .minute()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 12) {
                Text(post.text)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)

                favoriteButton
            }

            Text(post.createdAt, format: Self.createdAtStyle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(post.text), created \(post.createdAt.formatted(Self.createdAtStyle))")
        .accessibilityHint(post.isFavorite ? "Favorited" : "Not favorited")
    }

    private var favoriteButton: some View {
        Button(action: favoriteTapped) {
            Image(systemName: post.isFavorite ? "heart.fill" : "heart")
                .font(.title3)
                .symbolRenderingMode(.palette)
                .foregroundStyle(
                    post.isFavorite ? Color.red : Color.secondary,
                    post.isFavorite ? Color.red.opacity(0.35) : Color.clear
                )
                .scaleEffect(favoriteScale)
                .contentTransition(.symbolEffect(.replace))
        }
        .buttonStyle(.plain)
        .frame(minWidth: 44, minHeight: 44)
        .accessibilityLabel(post.isFavorite ? "Remove from favorites" : "Add to favorites")
        .sensoryFeedback(.impact(flexibility: .soft), trigger: post.isFavorite)
    }

    private func favoriteTapped() {
        withAnimation(.spring(duration: 0.4, bounce: 0.45)) {
            favoriteScale = 1.28
            onFavoriteTap()
        }

        withAnimation(.spring(duration: 0.35, bounce: 0.5).delay(0.08)) {
            favoriteScale = 1
        }
    }
}
