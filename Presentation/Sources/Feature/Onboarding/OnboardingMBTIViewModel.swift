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
    
    func mbtiDisplayText(_ mbti: MBTIEntity) -> String {
        switch mbti {
        case .intj: return "INTJ"
        case .intp: return "INTP"
        case .entj: return "ENTJ"
        case .entp: return "ENTP"
        case .infj: return "INFJ"
        case .infp: return "INFP"
        case .enfj: return "ENFJ"
        case .enfp: return "ENFP"
        case .istj: return "ISTJ"
        case .isfj: return "ISFJ"
        case .estj: return "ESTJ"
        case .esfj: return "ESFJ"
        case .istp: return "ISTP"
        case .isfp: return "ISFP"
        case .estp: return "ESTP"
        case .esfp: return "ESFP"
        }
    }
}
