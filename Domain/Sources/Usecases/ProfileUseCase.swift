//
//  ProfileUseCase.swift
//  Domain
//
//  Created by 신동규 on 8/14/25.
//

import Foundation

public final class ProfileUseCase {
    let jwtRepository: PJWTRepository
    let profileRepository: PProfileRepository
    
    public init(
        jwtRepository: PJWTRepository,
        profileRepository: PProfileRepository
    ) {
        self.jwtRepository = jwtRepository
        self.profileRepository = profileRepository
    }
    
    public func getMe() async throws -> ProfileEntitiy {
        guard let authTokens = jwtRepository.getTokens() else { throw AppError.authenticationError(.invalidCredentials) }
        return try await profileRepository.getMe(accessToken: authTokens.accessToken)
    }
    
    public func profileImageUpload(imageData: Data) async throws -> ProfileEntitiy {
        try await profileRepository.profileImageUpload(imageData: imageData)
    }
    
    public func uploadImage(imageData: Data) async throws -> ProfileEntitiy {
        try await profileRepository.uploadImage(imageData: imageData)
    }
    
    public func updateGender(gender: GenderEntity) async throws -> ProfileEntitiy {
        try await profileRepository.updateGender(gender: gender)
    }
    
    public func updatePhysicalInfo(height: CGFloat, weight: CGFloat) async throws -> ProfileEntitiy {
        try await profileRepository.updatePhysicalInfo(height: height, weight: weight)
    }
    
    public func deleteImage(publicId: String) async throws -> ProfileEntitiy {
        try await profileRepository.deleteImage(publicId: publicId)
    }
    
    public func updateNickname(nickname: String) async throws -> ProfileEntitiy {
        try await profileRepository.updateNickname(nickname: nickname)
    }
}
