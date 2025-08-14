//
//  MockJWTRepository.swift
//  DataSource
//
//  Created by 신동규 on 8/14/25.
//

import Domain

public final class MockJWTRepository: PJWTRepository {
    
    public init() {
        
    }
    
    public func saveTokens(_ tokens: AuthTokensEntity) {
        
    }
    
    public func getTokens() -> AuthTokensEntity? {
        return nil
    }
    
    public func refreshToken() async throws {
        
    }
    
    public func removeToken() {
        
    }
}
