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
    let accountRemoteDataSource = AccountRemoteDataSource()
    
    public init() {
        
    }
    
    public func loginOrSignup(id: String, type: String) async throws -> AuthTokensEntity {
        try await jwtRemoteDataSource.getAuthTokens(id: id, type: type)
    }
    
    public func logout() {
        jwtLocalDataSource.clearTokens()
    }
    
    public func searchAccount(email: String) async throws -> ProfileEntitiy {
        try await accountRemoteDataSource.searchAccount(email: email)
    }
    
    public func makeNewAccount(email: String, password: String) async throws -> AuthTokensEntity {
        let token = try await accountRemoteDataSource.makeNewAccount(email: email, password: password)
        jwtLocalDataSource.saveTokens(token)
        return token
    }
    
    public func login(email: String, password: String) async throws -> AuthTokensEntity {
        let token = try await accountRemoteDataSource.login(email: email, password: password)
        jwtLocalDataSource.saveTokens(token)
        return token
    }
}
