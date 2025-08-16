//
//  QnAFormViewModel.swift
//  DataSource
//
//  Created by 신동규 on 8/16/25.
//

import Domain
import Factory
import SwiftUI
import Combine

final class QnAFormViewModel: ObservableObject {
    
    @Published var examples: [QnAEntity] = []
    
    @Published var question: String = ""
    @Published var answer: String = ""
    @Published var placeholder: String = ""
    
    @Published var isVisibleExamples = false
    
    @Published var loading = false 
    
    let qnaUseCase = Container.shared.qnaUseCase()
    
    @MainActor
    func fetchExamples() async throws {
        examples = try await qnaUseCase.examples()
        try await Task.sleep(for: .seconds(0.5))
        withAnimation {
            isVisibleExamples = true
        }
    }
    
    func selectExample(_ example: QnAEntity) {
        question = example.question
        answer = ""
        placeholder = example.answer
    }
}
