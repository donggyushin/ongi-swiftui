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
    
    public func markViewed(profileId: String) async throws -> [ConnectedProfileEntity] {
        try await connectionRemoteDataSource.markViewed(profileId: profileId)
    }
    
    public func like(profileId: String) async throws {
        try await connectionRemoteDataSource.like(profileId: profileId)
    }
    public func cancelLike(profileId: String) async throws {
        try await connectionRemoteDataSource.cancelLike(profileId: profileId)
    }
}
