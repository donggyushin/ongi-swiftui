//
//  PasswordResetRemoteDataSource.swift
//  DataSource
//
//  Created by 신동규 on 9/2/25.
//

import Foundation
import Domain

final class PasswordResetRemoteDataSource {
    
    let networkManager = NetworkManager.shared
    
    func sendCode(email: String) async throws {
        let url = "\(ongiExpressUrl)password-reset/send-code"
        let parameters: [String: Any] = [
            "email": email
        ]
        
        let response: APIResponse<Empty> = try await networkManager.request(url: url, method: .post, parameters: parameters)
        
        guard response.success == false else { return }
        
        if let message = response.message {
            throw AppError.custom(message)
        } else if let error = response.error {
            throw AppError.custom(error)
        } else {
            throw AppError.networkError(.invalidResponse)
        }
    }
    
    func verifyCode(code: String) async throws -> String {
        let url = "\(ongiExpressUrl)password-reset/verify-code"
        let parameters: [String: Any] = [
            "code": code
        ]
        
        struct Response: Decodable {
            let email: String
        }
        
        let response: APIResponse<Response> = try await networkManager.request(url: url, method: .post, parameters: parameters)
        
        if let email = response.data?.email {
            return email
        } else if let message = response.message {
            throw AppError.custom(message)
        } else if let error = response.error {
            throw AppError.custom(error)
        } else {
            throw AppError.networkError(.invalidResponse)
        }
    }
    
    func reset(code: String, newPassword: String) async throws {
        let url = "\(ongiExpressUrl)password-reset/reset"
        let parameters: [String: Any] = [
            "code": code,
            "newPassword": newPassword
        ]
        let response: APIResponse<Empty> = try await networkManager.request(url: url, method: .post, parameters: parameters)
        
        guard response.success == false else { return }
        
        if let message = response.message {
            throw AppError.custom(message)
        } else if let error = response.error {
            throw AppError.custom(error)
        } else {
            throw AppError.networkError(.invalidResponse)
        }
    }
}
