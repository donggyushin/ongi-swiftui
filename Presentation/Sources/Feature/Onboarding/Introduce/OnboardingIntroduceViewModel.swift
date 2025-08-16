//
//  OnboardingIntroduceViewModel.swift
//  Presentation
//
//  Created by 신동규 on 8/16/25.
//

import Factory
import Domain
import SwiftUI
import Combine

final class OnboardingIntroduceViewModel: ObservableObject {
    @Published var introduceText = ""
    @Published var isLoading = false
    @Published var fetchingInitialData = true
    
    let profileUseCase = Container.shared.profileUseCase()
    
    let maxCharacterCount = 500
    
    var isValidIntroduce: Bool {
        !introduceText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && 
        introduceText.count <= maxCharacterCount &&
        introduceText.count >= 100
    }
    
    var characterCount: Int {
        introduceText.count
    }
    
    var remainingCharacters: Int {
        maxCharacterCount - characterCount
    }
    
    @MainActor
    func fetchInitialData() async throws {
        defer {
            withAnimation {
                fetchingInitialData = false
            }
        }
        introduceText = try await profileUseCase.getMe().introduce ?? ""
    }
    
    @MainActor
    func updateIntroduce() async throws {
        isLoading = true
        defer { isLoading = false }
        let updatedProfile = try await profileUseCase.updateIntroduce(introduce: introduceText)
        Container.shared.contentViewModel().me = updatedProfile
    }
}
