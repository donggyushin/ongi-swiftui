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

public final class QnAFormViewModel: ObservableObject {
    
    @Published var examples: [QnAEntity] = []
    
    @Published var question: String = ""
    @Published var answer: String = ""
    @Published var placeholder: String = ""
    
    @Published var isVisibleExamples = false
    
    @Published var loading = false 
    
    let qnaUseCase = Container.shared.qnaUseCase()
    
    var isValidForm: Bool {
        question.count >= 8 && answer.count >= 60
    }
    
    public init() { }
    
    @MainActor
    func registerQnA() async throws -> QnAEntity {
        loading = true
        defer { loading = false }
        let updatedProfile = try await qnaUseCase.add(question: question, answer: answer)
        Container.shared.contentViewModel().me = updatedProfile
        return updatedProfile.qnas.last!
    }
    
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
