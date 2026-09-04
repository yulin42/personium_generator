import SwiftUI

struct EmptyStateView: View {
    let title: String
    let message: String
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.system(.title3, design: .serif))
                .foregroundStyle(.primary)

            Text(message)
                .font(.callout)
                .foregroundStyle(.secondary)

            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .font(.callout.weight(.medium))
                    .buttonStyle(.plain)
                    .foregroundStyle(Color.accentColor)
                    .padding(.top, 14)
            }
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EmptyStateView(
        title: "Nothing here yet.",
        message: "Generate your first thoughts.",
        actionTitle: "Generate Posts",
        action: {}
    )
}
