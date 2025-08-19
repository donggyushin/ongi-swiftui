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
    
    public func markViewed(profileId: String) async throws -> [IsNewProfileEntitiy] {
        try await connectionRemoteDataSource.markViewed(profileId: profileId)
    }
}
