//
//  QnARepository.swift
//  Domain
//
//  Created by 신동규 on 8/16/25.
//

import Domain

public final class QnARepository: PQnARepository {
    
    let qnaRemoteDataSource = QnARemoteDataSource()
    
    public init() { }
    
    public func getExamples() async throws -> [QnAEntity] {
        try await qnaRemoteDataSource.examples()
    }
}
