//
//  GenerateViewModel.swift
//  personium
//

import Foundation
import Observation

@Observable
@MainActor
final class GenerateViewModel {
    private let generationService: GenerationService

    var selectedCategory: GenerateCategory = .reflection
    var selectedBatchSize: BatchSize = .ten
    var isGenerating = false
    var lastGeneratedBatch: Batch?

    init(generationService: GenerationService) {
        self.generationService = generationService
    }

    func generate() async {
        guard !isGenerating else { return }

        isGenerating = true
        defer { isGenerating = false }

        do {
            lastGeneratedBatch = try await generationService.generate(
                category: selectedCategory,
                count: selectedBatchSize.rawValue
            )
        } catch {
            lastGeneratedBatch = nil
        }
    }
}

extension GenerateViewModel {
    static func preview(generationService: GenerationService) -> GenerateViewModel {
        GenerateViewModel(generationService: generationService)
    }

    static func loadingPreview(generationService: GenerationService) -> GenerateViewModel {
        let viewModel = GenerateViewModel(generationService: generationService)
        viewModel.isGenerating = true
        return viewModel
    }
}
