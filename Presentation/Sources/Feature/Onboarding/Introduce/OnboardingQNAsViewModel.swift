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
    @Published var fetchingInitialData = true
    @Published var loading = false
    
    var isEnoughQNAs: Bool {
        qnas.count >= 6 
    }
    
    let profileUseCase = Container.shared.profileUseCase()
    let qnaUseCase = Container.shared.qnaUseCase()
    
    @MainActor
    func deleteQNA(at: Int) async throws {
        loading = true
        defer { loading = false }
        let qna = qnas[at]
        let updatedProfile = try await qnaUseCase.delete(qnaId: qna.id)
        Container.shared.contentViewModel().me = updatedProfile
        _ = withAnimation {
            qnas.remove(at: at)
        }
    }
    
    @MainActor
    func fetchInitialData() async throws {
        
        defer {
            withAnimation {
                fetchingInitialData = false
            }
        }
        
        qnas = try await profileUseCase.getMe().qnas
    }
}
