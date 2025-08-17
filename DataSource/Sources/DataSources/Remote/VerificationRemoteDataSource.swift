//
//  VerificationRemoteDataSource.swift
//  DataSource
//
//  Created by 신동규 on 8/17/25.
//

import Foundation
import Domain

final class VerificationRemoteDataSource {
    
    let networkManager = NetworkManager.shared
    
    init() { }
    
    func sendCompany(email: String) async throws {
        let parameters = [
            "email": email
        ]
        
        let url = "\(ongiExpressUrl)email-verification/send-company"
        
        let response: APIResponse<Empty> = try await networkManager
            .request(url: url, method: .post, parameters: parameters)
        
        if response.success == false {
            if let message = response.message {
                throw AppError.custom(message)
            } else {
                throw AppError.networkError(.invalidResponse)
            }
        }
    }
    
    func verify(code: String) async throws {
        let parameters = [
            "code": code
        ]
        
        let url = "\(ongiExpressUrl)email-verification/verify"
        
        let response: APIResponse<Empty> = try await networkManager
            .request(url: url, method: .post, parameters: parameters)
        
        if response.success == false {
            if let message = response.message {
                throw AppError.custom(message)
            } else {
                throw AppError.networkError(.invalidResponse)
            }
        }
    }
}
