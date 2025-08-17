//
//  OnboardingMBTIViewModel.swift
//  Presentation
//
//  Created by 신동규 on 8/16/25.
//

import Factory
import Domain
import SwiftUI
import Combine

final class OnboardingMBTIViewModel: ObservableObject {
    @Published var selectedMBTI: MBTIEntity?
    @Published var isLoading = false
    @Published var fetchingInitialData = true
    
    let profileUseCase = Container.shared.profileUseCase()
    
    let mbtiOptions = MBTIEntity.allCases
    
    @MainActor
    func updateMBTI() async throws {
        isLoading = true
        defer { isLoading = false }
        guard let selectedMBTI else { return }
        let updatedProfile = try await profileUseCase.updateMBTI(mbti: selectedMBTI)
        Container.shared.contentViewModel().me = updatedProfile
    }
    
    @MainActor
    func fetchInitialData() async throws {
        defer {
            withAnimation {
                fetchingInitialData = false
            }
        }
        selectedMBTI = try await profileUseCase.getMe().mbti
    }
    
    func selectMBTI(_ mbti: MBTIEntity) {
        selectedMBTI = mbti
    }
}
