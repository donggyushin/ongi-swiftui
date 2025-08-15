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
    
    @Published var profileImage: UIImage?
    @Published var showImagePicker = false
    @Published var showActionSheet = false
    
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
        }
    }
    
    func selectImage() {
        showImagePicker = true
    }
    
    func uploadPhoto() async throws {
        guard let profileImage else { throw AppError.unknown(nil) }
        guard let data = profileImage.jpegData(compressionQuality: 0.8) else { throw AppError.unknown(nil) }
        let updatedProfile = try await profileUseCase.profileImageUpload(imageData: data)
        
        await MainActor.run {
            Container.shared.contentViewModel().me = updatedProfile
        }
    }
}
