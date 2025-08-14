//
//  MockJWTRepository.swift
//  DataSource
//
//  Created by 신동규 on 8/14/25.
//

import Domain

public final class MockJWTRepository: PJWTRepository {
    
    public init() {
        print("mock init")
    }
    
    public func saveTokens(_ tokens: Domain.AuthTokensEntity) {
        
    }
    
    public func getTokens() -> Domain.AuthTokensEntity? {
        return nil
    }
    
    public func refreshToken() async throws {
        
    }
    
    
}
