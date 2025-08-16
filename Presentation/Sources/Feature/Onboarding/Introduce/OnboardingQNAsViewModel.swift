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
    
    @MainActor
    func addQnA(_ qna: QnAEntity) async throws {
        qnas.append(qna)
        
        // TODO: - update me in contentviewmodel
    }
    
    @MainActor
    func deleteQNA(at: Int) async throws {
        qnas.remove(at: at)
        
        // TODO: - update me in contentviewmodel
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
