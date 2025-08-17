//
//  ConnectionUseCase.swift
//  Domain
//
//  Created by 신동규 on 8/17/25.
//

public final class ConnectionUseCase {
    let connectionRepository: PConnectionRepository
    
    public init(connectionRepository: PConnectionRepository) {
        self.connectionRepository = connectionRepository
    }
    
    public func getConnection() async throws -> ConnectionEntity {
        try await connectionRepository.getConnection()
    }
}
