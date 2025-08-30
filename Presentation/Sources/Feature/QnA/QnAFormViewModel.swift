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
    
    let qnaId: String?
    
    @Published var examples: [QnAEntity] = []
    
    @Published var question: String = ""
    @Published var answer: String = ""
    @Published var placeholder: String = ""
    
    @Published var isVisibleExamples = false
    
    @Published var loading = false 
    
    @Injected(\.qnaUseCase) private var qnaUseCase
    @Injected(\.contentViewModel) private var contentViewModel
    
    var isValidForm: Bool {
        question.count >= 8 && answer.count >= 60
    }
    
    public init(qnaId: String?) {
        self.qnaId = qnaId
    }
    
    @MainActor
    func registerQnA() async throws {
        guard loading == false else { return }
        loading = true
        defer { loading = false }
        
        if let qnaId {
            let updatedProfile = try await qnaUseCase.update(qnaId: qnaId, answer: answer)
            contentViewModel.me = updatedProfile
        } else {
            let updatedProfile = try await qnaUseCase.add(question: question, answer: answer)
            contentViewModel.me = updatedProfile
        }
    }
    
    @MainActor
    func fetchExamples() async throws {
        
        if let qnaId {
            let qna = try await qnaUseCase.getQnA(qnaId: qnaId)
            question = qna.question
            answer = qna.answer
        } else {
            examples = try await qnaUseCase.examples()
            try await Task.sleep(for: .seconds(0.5))
            withAnimation {
                isVisibleExamples = true
            }
        }
    }
    
    func selectExample(_ example: QnAEntity) {
        question = example.question
        answer = ""
        placeholder = example.answer
    }
}
