//
//  MockAuthRepository.swift
//  Domain
//
//  Created by 신동규 on 8/14/25.
//

import Domain

final class MockAuthRepository: PAuthRepository {
    
    func loginOrSignup(id: String, type: String) async throws -> AuthTokensEntity {
        throw AppError.unknown(nil)
    }
    
    func logout() {
        
    }
}
