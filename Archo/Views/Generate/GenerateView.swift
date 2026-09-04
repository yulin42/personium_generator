import SwiftData
import SwiftUI

struct GenerateView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = GenerateViewModel()

    /// Reveals the new posts by switching to the Feed tab.
    var onGenerated: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 34) {
                section("Topic") {
                    TopicPicker(selection: $viewModel.topic)
                }

                section("Number of posts") {
                    PostCountPicker(selection: $viewModel.postCount)
                }

                if let errorMessage = viewModel.errorMessage {
                    errorBanner(errorMessage)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            .padding(.bottom, 32)
            .animation(.snappy(duration: 0.25), value: viewModel.errorMessage)
        }
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .bottom) { callToAction }
        .navigationTitle("Generate")
    }

    private var callToAction: some View {
        VStack(spacing: 10) {
            PrimaryButton(
                title: "Generate \(viewModel.postCount.rawValue) Posts",
                isLoading: viewModel.isGenerating,
                action: generate
            )

            // Kept in the layout at all times so the button doesn't shift.
            Text("Writing…")
                .font(.caption)
                .foregroundStyle(.secondary)
                .opacity(viewModel.isGenerating ? 1 : 0)
                .accessibilityHidden(!viewModel.isGenerating)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(.bar)
    }

    private func section(
        _ title: String,
        @ViewBuilder content: () -> some View
    ) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title.uppercased())
                .font(.caption2.weight(.medium))
                .tracking(1.1)
                .foregroundStyle(.tertiary)

            content()
        }
    }

    private func errorBanner(_ message: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(message)
                .font(.callout)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Button("Try Again", action: generate)
                .font(.callout.weight(.medium))
                .buttonStyle(.plain)
                .foregroundStyle(Color.accentColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(.fill.quaternary, in: .rect(cornerRadius: 16, style: .continuous))
    }

    private func generate() {
        Task {
            if await viewModel.generate(into: modelContext) {
                onGenerated()
            }
        }
    }
}

#Preview {
    NavigationStack {
        GenerateView(onGenerated: {})
    }
    .modelContainer(PreviewData.container(includePosts: false))
}
