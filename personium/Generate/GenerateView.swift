//
//  GenerateView.swift
//  personium
//

import SwiftUI

struct GenerateView: View {
    @State private var viewModel: GenerateViewModel
    private let onGenerated: ([Post]) -> Void

    init(
        viewModel: GenerateViewModel = GenerateViewModel(),
        onGenerated: @escaping ([Post]) -> Void = { _ in }
    ) {
        _viewModel = State(initialValue: viewModel)
        self.onGenerated = onGenerated
    }

    var body: some View {
        Form {
            categorySection
            batchSizeSection
            generateSection
        }
        .disabled(viewModel.isGenerating)
        .navigationTitle("Generate")
        .navigationBarTitleDisplayMode(.large)
    }

    private var categorySection: some View {
        Section {
            Picker("Category", selection: $viewModel.selectedCategory) {
                ForEach(GenerateCategory.allCases) { category in
                    Text(category.displayName)
                        .tag(category)
                }
            }
            .pickerStyle(.inline)
            .accessibilityLabel("Category")
        } header: {
            Text("Category")
        }
    }

    private var batchSizeSection: some View {
        Section {
            Picker("Batch Size", selection: $viewModel.selectedBatchSize) {
                ForEach(BatchSize.allCases) { size in
                    Text(size.label)
                        .tag(size)
                }
            }
            .pickerStyle(.segmented)
            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
            .accessibilityLabel("Batch size")
        } header: {
            Text("Batch Size")
        }
    }

    private var generateSection: some View {
        Section {
            if viewModel.isGenerating {
                HStack(spacing: 12) {
                    ProgressView()
                    Text("Generating thoughts...")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Generating thoughts")
            }

            Button(action: generateTapped) {
                Text("Generate Posts")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .listRowInsets(EdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0))
            .disabled(viewModel.isGenerating)
            .accessibilityHint("Creates a new batch of posts")
        }
    }

    private func generateTapped() {
        Task {
            let posts = await viewModel.generate()
            guard !posts.isEmpty else { return }
            onGenerated(posts)
        }
    }
}

// MARK: - Previews

#Preview("Generate") {
    NavigationStack {
        GenerateView { posts in
            print("Generated \(posts.count) posts")
        }
    }
}

#Preview("Loading") {
    NavigationStack {
        GenerateView(viewModel: .loadingPreview)
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        GenerateView()
    }
    .preferredColorScheme(.dark)
}
