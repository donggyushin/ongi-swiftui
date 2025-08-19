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
    
    func markViewed(profileId: String) async throws -> [ConnectedProfileEntity] {
        let url = "\(ongiExpressUrl)profile-connections/\(profileId)/mark-viewed"
        
        struct ResponseData: Decodable {
            let otherProfiles: [ConnectedProfileDTO]
        }
        
        let response: APIResponse<ResponseData> = try await networkManager
            .request(url: url, method: .patch)
        
        if let profiles = response.data?.otherProfiles.compactMap({ $0.toDomainEntity() }) {
            return profiles
        } else if let message = response.message {
            throw AppError.custom(message)
        } else {
            throw AppError.networkError(.invalidResponse)
        }
    }
}
