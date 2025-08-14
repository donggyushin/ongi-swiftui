//
//  ProfileRemoteDataSource.swift
//  DataSource
//
//  Created by 신동규 on 8/15/25.
//

import Domain

final class ProfileRemoteDataSource {
    let networkManager = NetworkManager.shared
    
    func getMe(accessToken: String) async throws -> ProfileEntitiy {
        struct DTO: Decodable {
            let profile: ProfileResponseDTO
        }
        
        let response: APIResponse<DTO> = try await networkManager.request(url: "\(ongiExpressUrl)accounts/me")
        if let profile = response.data?.profile.toDomainEntity() {
            return profile
        } else if let message = response.message {
            throw AppError.custom(message)
        } else {
            throw AppError.networkError(.invalidResponse)
        }
    }
}
