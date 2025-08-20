//
//  OnboardingNicknameViewModel.swift
//  Presentation
//
//  Created by 신동규 on 8/16/25.
//

import Factory
import Domain
import Combine
import SwiftUI

final class OnboardingNicknameViewModel: ObservableObject {
    
    @Published var nickname = ""
    @Published var loading = false
    @Published var errorMessage: String?
    
    @Published var fetchingInitialData = true
    
    @Injected(\.profileUseCase) private var profileUseCase
    @Injected(\.contentViewModel) private var contentViewModel
    
    init() { }
    
    var isNicknameValid: Bool {
        return nickname.trimmingCharacters(in: .whitespacesAndNewlines).count >= 2 &&
               nickname.trimmingCharacters(in: .whitespacesAndNewlines).count <= 10
    }
    
    @MainActor
    func updateNickname() async throws {
        guard isNicknameValid else {
            errorMessage = "닉네임은 2자 이상 10자 이하로 입력해주세요"
            return
        }
        
        loading = true
        defer { loading = false }
        
        let trimmedNickname = nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        let updatedProfile = try await profileUseCase.updateNickname(nickname: trimmedNickname)
        
        contentViewModel.me = updatedProfile
        errorMessage = nil
    }
    
    @MainActor
    func fetchCurrentNickname() async throws {
        let myProfile = try await profileUseCase.getMe()
        nickname = myProfile.nickname
        withAnimation {
            fetchingInitialData = false
        }
    }
}
