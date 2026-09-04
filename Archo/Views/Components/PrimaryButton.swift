import SwiftUI

struct PrimaryButton: View {
    let title: String
    var isLoading: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Text(title)
                    .opacity(isLoading ? 0 : 1)

                if isLoading {
                    ProgressView()
                        .tint(.white)
                }
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 17)
            .background(Color.accentColor, in: .capsule)
            .foregroundStyle(.white)
        }
        .buttonStyle(.plain)
        .disabled(isLoading)
        .animation(.easeInOut(duration: 0.2), value: isLoading)
    }
}

#Preview {
    VStack(spacing: 16) {
        PrimaryButton(title: "Generate Posts", action: {})
        PrimaryButton(title: "Generate Posts", isLoading: true, action: {})
    }
    .padding()
}
