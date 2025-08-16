//
//  QnARemoteDataSource.swift
//  DataSource
//
//  Created by 신동규 on 8/16/25.
//

import Domain
import Foundation

final class QnARemoteDataSource {
    
    let networkManager = NetworkManager.shared
    
    func examples() async throws -> [QnAEntity] {
        let url = "\(ongiExpressUrl)qna/examples"
        let response: APIResponse<[QnAResponseDTO]>
        
        response = try await networkManager.request(url: url)
        
        if let qnas = response.data?.compactMap({ $0.toDomainEntity() }) {
            return qnas
        } else if let message = response.message {
            throw AppError.custom(message)
        } else {
            throw AppError.networkError(.invalidResponse)
        }
    }
}
