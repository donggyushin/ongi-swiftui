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
}
