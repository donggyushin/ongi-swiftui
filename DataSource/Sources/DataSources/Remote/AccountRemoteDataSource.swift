//
//  AccountRemoteDataSource.swift
//  DataSource
//
//  Created by 신동규 on 9/1/25.
//

import Foundation
import Domain

final class AccountRemoteDataSource {
    private let networkManager = NetworkManager.shared
    
    func searchAccount(email: String) async throws -> ProfileEntitiy {
        let url = "\(ongiExpressUrl)accounts/by-email?email=email"
        struct Response: Decodable {
            let profile: ProfileResponseDTO
        }
        
        let response: APIResponse<Response> = try await networkManager.request(url: url)
        
        if let profile = response.data?.profile.toDomainEntity() {
            return profile
        } else if let message = response.message {
            throw AppError.custom(message)
        } else {
            throw AppError.networkError(.invalidResponse)
        }
    }
}
