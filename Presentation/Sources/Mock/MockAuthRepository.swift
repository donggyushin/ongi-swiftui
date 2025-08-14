//
//  MockAuthRepository.swift
//  Domain
//
//  Created by 신동규 on 8/14/25.
//

import Domain

public final class MockAuthRepository: PAuthRepository {
    public func loginOrSignup(id: String, type: String) async throws -> AuthTokensEntity {
        throw AppError.unknown(nil)
    }
    
    public func logout() {
        
    }
}
