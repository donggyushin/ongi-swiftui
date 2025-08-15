//
//  OnboardingViewModel.swift
//  DataSource
//
//  Created by 신동규 on 8/15/25.
//

import Domain
import Combine
import Factory

public final class OnboardingViewModel: ObservableObject {
    
    @Published var path: [OnboardingNavigationPath] = []
    @Published var myProfile: ProfileEntitiy?
    
    var skipMultipleImages = false
    
    let profileUseCase: ProfileUseCase
    
    public init() {
        profileUseCase = Container.shared.profileUseCase()
    }
    
    @MainActor
    func updateProfile() async throws {
        myProfile = try await profileUseCase.getMe()
    }
    
    @MainActor
    func nextStep() {
        guard let myProfile else { return }
        
        if myProfile.profileImage == nil {
            path.append(.profileImage)
        } else if myProfile.images.isEmpty && skipMultipleImages == false {
            path.append(.images)
        } else if myProfile.gender == nil {
            path.append(.physicalAndGender)
        }
    }
}
