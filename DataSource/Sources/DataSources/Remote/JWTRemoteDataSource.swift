//
//  JWTRemoteDataSource.swift
//  DataSource
//
//  Created by 신동규 on 8/14/25.
//

import Foundation
import Domain

final class JWTRemoteDataSource {
    
    let networkManager = NetworkManager.shared
    
    public func refreshToken(refreshToken: String) async throws -> AuthTokensEntity {
        let response: APIResponse<AuthTokensResponseDTO> = try await networkManager.request(url: "\(ongiExpressUrl)accounts/refresh")
        if let authTokens = response.data?.toDomainEntity() {
            return authTokens
        } else if let message = response.message {
            throw AppError.custom(message)
        } else {
            throw AppError.networkError(.invalidResponse)
        }
    }
}
