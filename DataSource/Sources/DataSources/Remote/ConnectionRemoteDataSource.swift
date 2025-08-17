//
//  ConnectionRemoteDataSource.swift
//  DataSource
//
//  Created by 신동규 on 8/17/25.
//

import Domain

final class ConnectionRemoteDataSource {
    let networkManager = NetworkManager.shared
    
    func getConnection() async throws -> ConnectionEntity {
        let url = "\(ongiExpressUrl)profile-connections/profiles"
        
        let response: APIResponse<ConnectionResponseDTO> = try await networkManager
            .request(url: url)
        
        if let connection = response.data?.toDomainEntity() {
            return connection
        } else if let message = response.message {
            throw AppError.custom(message)
        } else {
            throw AppError.networkError(.invalidResponse)
        }
    }
}
