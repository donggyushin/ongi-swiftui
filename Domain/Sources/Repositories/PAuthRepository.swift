//
//  PAuthRepository.swift
//  Domain
//
//  Created by 신동규 on 8/14/25.
//

public protocol PAuthRepository {
    func loginOrSignup(id: String, type: String) async throws -> AuthTokensEntity
    func logout()
    func searchAccount(email: String) async throws -> ProfileEntitiy
    func makeNewAccount(email: String, password: String) async throws -> AuthTokensEntity
    func login(email: String, password: String) async throws -> AuthTokensEntity
}
