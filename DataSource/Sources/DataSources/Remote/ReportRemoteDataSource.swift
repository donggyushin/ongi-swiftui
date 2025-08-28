//
//  ReportRemoteDataSource.swift
//  DataSource
//
//  Created by 신동규 on 8/28/25.
//

import Foundation
import Domain

final class ReportRemoteDataSource {
    let networkManager = NetworkManager.shared
    
    func report(profileId: String, content: String) async throws {
        let url = "\(ongiExpressUrl)reports/\(profileId)"
        
        let parameter: [String: Any] = [
            "content": content
        ]
        
        let response: APIResponse<Empty> = try await networkManager.request(url: url, method: .post, parameters: parameter)
        
        if response.success == false {
            if let message = response.message {
                throw AppError.custom(message)
            } else {
                throw AppError.networkError(.invalidResponse)
            }
        }
    }
}
