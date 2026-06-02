//
//  GenerateView.swift
//  personium
//

import SwiftUI

struct GenerateView: View {
    @Environment(\.appDependencies) private var dependencies

    @State private var viewModel: GenerateViewModel?

    init(viewModel: GenerateViewModel? = nil) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        Form {
            categorySection
            batchSizeSection
            generateSection
        }
        .disabled(viewModel?.isGenerating == true)
        .navigationTitle("Generate")
        .navigationBarTitleDisplayMode(.large)
        .onAppear(perform: configureViewModelIfNeeded)
    }

    private var categorySection: some View {
        Section {
            Picker("Category", selection: categoryBinding) {
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
            Picker("Batch Size", selection: batchSizeBinding) {
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
            if viewModel?.isGenerating == true {
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
            .disabled(viewModel?.isGenerating == true)
            .accessibilityHint("Creates a new batch of posts")
        }
    }

    private var categoryBinding: Binding<GenerateCategory> {
        Binding(
            get: { viewModel?.selectedCategory ?? .reflection },
            set: { viewModel?.selectedCategory = $0 }
        )
    }

    private var batchSizeBinding: Binding<BatchSize> {
        Binding(
            get: { viewModel?.selectedBatchSize ?? .ten },
            set: { viewModel?.selectedBatchSize = $0 }
        )
    }

    private func configureViewModelIfNeeded() {
        guard viewModel == nil, let dependencies else { return }
        viewModel = GenerateViewModel(generationService: dependencies.generationService)
    }

    private func generateTapped() {
        guard let viewModel else { return }
        Task {
            await viewModel.generate()
        }
    }
}

#Preview("Generate") {
    let container = PreviewSampleData.makeContainer(includePosts: false)
    let dependencies = AppDependencies(modelContext: container.mainContext)

    return NavigationStack {
        GenerateView()
            .environment(\.appDependencies, dependencies)
    }
    .modelContainer(container)
}

#Preview("Loading") {
    let container = PreviewSampleData.makeContainer(includePosts: false)
    let dependencies = AppDependencies(modelContext: container.mainContext)

    return NavigationStack {
        GenerateView(
            viewModel: .loadingPreview(generationService: dependencies.generationService)
        )
        .environment(\.appDependencies, dependencies)
    }
    .modelContainer(container)
}

#Preview("Dark Mode") {
    let container = PreviewSampleData.makeContainer(includePosts: false)
    let dependencies = AppDependencies(modelContext: container.mainContext)

    return NavigationStack {
        GenerateView()
            .environment(\.appDependencies, dependencies)
    }
    .modelContainer(container)
    .preferredColorScheme(.dark)
}
