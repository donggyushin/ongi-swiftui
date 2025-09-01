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
    
    func searchAccount(email: String) async throws -> ProfileEntitiy {
        throw AppError.custom("존재하지 않는 유저", code: nil)
    }
    
    func makeNewAccount(email: String, password: String) async throws -> AuthTokensEntity {
        return .init(accessToken: "", refreshToken: "")
    }
}
