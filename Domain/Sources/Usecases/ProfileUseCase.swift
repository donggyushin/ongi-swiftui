//
//  ProfileUseCase.swift
//  Domain
//
//  Created by 신동규 on 8/14/25.
//

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
    
    public func getMe() async throws -> ProfileEntitiy? {
        guard let authTokens = jwtRepository.getTokens() else { return nil }
        return try await profileRepository.getMe(accessToken: authTokens.accessToken)
    }
}
