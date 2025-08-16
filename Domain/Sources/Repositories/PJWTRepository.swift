//
//  PJWTRepository.swift
//  Domain
//
//  Created by 신동규 on 8/14/25.
//

public protocol PJWTRepository {
    func saveTokens(_ tokens: AuthTokensEntity)
    func getTokens() -> AuthTokensEntity?
    func removeToken()
    func refreshToken() async throws
}
