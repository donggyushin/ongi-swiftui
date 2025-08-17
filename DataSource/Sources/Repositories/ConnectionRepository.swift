//
//  ConnectionRepository.swift
//  DataSource
//
//  Created by 신동규 on 8/17/25.
//

import Domain

public final class ConnectionRepository: PConnectionRepository {
    
    let connectionRemoteDataSource = ConnectionRemoteDataSource()
    
    public init() { }
    
    public func getConnection() async throws -> ConnectionEntity {
        try await connectionRemoteDataSource.getConnection()
    }
}
