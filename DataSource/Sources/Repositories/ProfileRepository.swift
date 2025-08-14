//
//  ProfileRepository.swift
//  DataSource
//
//  Created by 신동규 on 8/14/25.
//

import Domain

public final class ProfileRepository: PProfileRepository {
    
    public static let shared = ProfileRepository()
    
    let networkManager = NetworkManager.shared
    
    private init() {
        
    }
    
    public func getMe(accessToken: String) async throws -> ProfileEntitiy {
        let response: APIResponse<ProfileResponseDTO> = try await networkManager.request(url: "\(ongiExpressUrl)")
        
        if let profile = response.data?.toDomainEntity() {
            return profile
        } else if let message = response.message {
            throw AppError.custom(message)
        } else {
            throw AppError.networkError(.invalidResponse)
        }
    }
    
    
}
