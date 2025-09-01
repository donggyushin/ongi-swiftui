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
        let url = "\(ongiExpressUrl)accounts/by-email?email=\(email)"
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
    
    func makeNewAccount(email: String, password: String) async throws -> AuthTokensEntity {
        let url = "\(ongiExpressUrl)accounts/email-password"
        
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        let response: APIResponse<AuthTokensResponseDTO> = try await networkManager.request(url: url, method: .post, parameters: parameters)
        
        if let token = response.data?.toDomainEntity() {
            return token
        } else if let message = response.message {
            throw AppError.custom(message)
        } else {
            throw AppError.networkError(.invalidResponse)
        }
    }
    
    func login(email: String, password: String) async throws -> AuthTokensEntity {
        let url = "\(ongiExpressUrl)accounts/login"
        
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        let response: APIResponse<AuthTokensResponseDTO> = try await networkManager.request(url: url, method: .post, parameters: parameters)
        
        if let token = response.data?.toDomainEntity() {
            return token
        } else if let message = response.message {
            throw AppError.custom(message)
        } else {
            throw AppError.networkError(.invalidResponse)
        }
    }
}
