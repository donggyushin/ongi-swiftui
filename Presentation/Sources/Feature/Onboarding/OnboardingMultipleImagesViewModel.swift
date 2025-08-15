//
//  OnboardingMultipleImagesViewModel.swift
//  Presentation
//
//  Created by 신동규 on 8/15/25.
//

import Domain
import Factory
import Combine
import SwiftUI
import Kingfisher

final class OnboardingMultipleImagesViewModel: ObservableObject {
    
    @Published var images: [UIImage] = []
    @Published var fetchingInitialData = true
    
    let profileUseCase: ProfileUseCase
    
    init() {
        profileUseCase = Container.shared.profileUseCase()
    }
    
    @MainActor
    func fetchInitialImages() async throws {
        let myProfile = try await profileUseCase.getMe()
        myProfile.images.forEach { image in
            
        }
        
        images = []
        
        try await Task.sleep(for: .seconds(0.5))
        
        withAnimation {
            fetchingInitialData = false
        }
    }
}
