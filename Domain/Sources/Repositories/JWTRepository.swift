//
//  JWTRepository.swift
//  Domain
//
//  Created by 신동규 on 8/14/25.
//

public protocol PJWTRepository {
    // local datasource
    func saveTokens(_ tokens: AuthTokensEntity)
    func getTokens() -> AuthTokensEntity?
    // remote datasource
    func refreshToken() async throws
    func removeToken()
}
