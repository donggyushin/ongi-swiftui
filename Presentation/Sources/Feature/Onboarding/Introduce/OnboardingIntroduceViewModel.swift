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
    
    @Injected(\.profileUseCase) var profileUseCase
    @Injected(\.contentViewModel) var contentViewModel
    
    let maxCharacterCount = 500
    let minCharacterCount = 50
    
    var isValidIntroduce: Bool {
        !introduceText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && 
        introduceText.count <= maxCharacterCount &&
        introduceText.count >= minCharacterCount
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
        introduceText = try await profileUseCase.getMe().introduction ?? ""
    }
    
    @MainActor
    func updateIntroduce() async throws {
        isLoading = true
        defer { isLoading = false }
        let updatedProfile = try await profileUseCase.updateIntroduce(introduce: introduceText)
        contentViewModel.me = updatedProfile
    }
}
