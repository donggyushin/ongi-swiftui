//
//  MockJWTRepository.swift
//  DataSource
//
//  Created by 신동규 on 8/14/25.
//

import Domain

final class MockJWTRepository: PJWTRepository {
    
    init() {
        
    }
    
    func saveTokens(_ tokens: AuthTokensEntity) {
        
    }
    
    func getTokens() -> AuthTokensEntity? {
        return nil
    }
    
    func refreshToken() async throws {
        
    }
    
    func removeToken() {
        
    }
}
