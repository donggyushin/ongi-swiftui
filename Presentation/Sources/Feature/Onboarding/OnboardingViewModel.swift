//
//  OnboardingViewModel.swift
//  DataSource
//
//  Created by 신동규 on 8/15/25.
//

import Domain
import Combine
import Factory
import Foundation
import SwiftUI

public final class OnboardingViewModel: ObservableObject {
    
    @Published var path: [OnboardingNavigationPath] = []
    @Published var myProfile: ProfileEntitiy?
    
    var skipMultipleImages = false
    var skipProfileCompletion = false
    
    private var cancellables = Set<AnyCancellable>()
    
    public init() {
        bind()
    }
    
    private func bind() {
        Container.shared.contentViewModel()
            .$me
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .assign(to: &$myProfile)
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
        } else if myProfile.email == nil {
            path.append(.email)
        } else {
            path.append(.complete)
        }
    }
}
