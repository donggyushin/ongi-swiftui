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
    var skipProfileCompletion = false
    
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
        
        if path.isEmpty {
            path.append(.nickname)
            return
        }
        
        guard let myProfile else { return }
        
        if myProfile.profileImage == nil {
            path.append(.profileImage)
        } else if myProfile.images.isEmpty && skipMultipleImages == false {
            path.append(.images)
            skipMultipleImages = true 
        } else if myProfile.gender == nil {
            path.append(.physicalAndGender)
        } else if skipProfileCompletion == false && myProfile.mbti == nil {
            path.append(.profileSectionCompletion)
            skipProfileCompletion = true
        } else if myProfile.mbti == nil {
            path.append(.mbti)
        } else if myProfile.introduce == nil {
            path.append(.introduce)
        } else if myProfile.qnas.isEmpty {
            path.append(.qnas)
        }
    }
}
