//
//  AuthRepository.swift
//  DataSource
//
//  Created by 신동규 on 8/14/25.
//

import Domain

public final class AuthRepository: PAuthRepository {
    
    let jwtLocalDataSource = JWTLocalDataSource()
    let jwtRemoteDataSource = JWTRemoteDataSource()
    
    public init() {
        
    }
    
    public func loginOrSignup(id: String, type: String) async throws -> AuthTokensEntity {
        try await jwtRemoteDataSource.getAuthTokens(id: id, type: type)
    }
    
    public func logout() {
        jwtLocalDataSource.clearTokens()
    }
}
