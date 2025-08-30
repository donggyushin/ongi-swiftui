//
//  OnboardingQNAsViewModel.swift
//  Presentation
//
//  Created by 신동규 on 8/16/25.
//

import Domain
import SwiftUI
import Combine
import Factory

final class OnboardingQNAsViewModel: ObservableObject {
    @Published var qnas: [QnAEntity] = []
    @Published var loading = false
    
    var isEnoughQNAs: Bool {
        qnas.count >= 6 
    }
    
    @Injected(\.profileUseCase) private var profileUseCase
    @Injected(\.qnaUseCase) private var qnaUseCase
    @Injected(\.contentViewModel) private var contentViewModel
    
    init() { }
    
    @MainActor
    func addNewQnA(_ qna: QnAEntity) {
        withAnimation {
            qnas.append(qna)
        }
    }
    
    @MainActor
    func deleteQNA(at: Int) async throws {
        loading = true
        defer { loading = false }
        let qna = qnas[at]
        let updatedProfile = try await qnaUseCase.delete(qnaId: qna.id)
        contentViewModel.me = updatedProfile
        _ = withAnimation {
            qnas.remove(at: at)
        }
    }
    
    @MainActor
    func fetchInitialData() async throws {
        qnas = try await profileUseCase.getMe().qnas
    }
}
