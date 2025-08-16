//
//  OnboardingProfileImageViewModel.swift
//  Presentation
//
//  Created by 신동규 on 8/15/25.
//

import Domain
import Combine
import SwiftUI
import Factory
@preconcurrency import Kingfisher

@preconcurrency
public final class OnboardingProfileImageViewModel: ObservableObject {
    
    @Published var loadingInitialImage = true
    
    @Published var profileImage: UIImage?
    @Published var showImagePicker = false
    @Published var showActionSheet = false
    
    @Published var loading = false
    
    let profileUseCase: ProfileUseCase
    
    public init() {
        profileUseCase = Container.shared.profileUseCase()
    }
    
    func updateProfileImage() {
        Task {
            do {
                let me = try await profileUseCase.getMe()
                guard let url = me.profileImage?.url else { return }
                KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
                    switch result {
                    case .success(let result):
                        DispatchQueue.main.async {
                            self?.profileImage = result.image
                        }
                    case .failure(_):
                        break
                    }
                }
            } catch {
                print("Failed to load profile image: \(error)")
            }
            
            try await Task.sleep(for: .seconds(0.5))
            
            await MainActor.run {
                withAnimation {
                    loadingInitialImage = false
                }
            }
        }
    }
    
    func selectImage() {
        showImagePicker = true
    }
    
    @MainActor
    func uploadPhoto() async throws {
        
        loading = true
        defer { loading = false }
        
        guard let profileImage else { throw AppError.unknown(nil) }
        guard let data = profileImage.jpegData(compressionQuality: 0.8) else { throw AppError.unknown(nil) }
        let updatedProfile = try await profileUseCase.profileImageUpload(imageData: data)
        Container.shared.contentViewModel().me = updatedProfile
    }
}
