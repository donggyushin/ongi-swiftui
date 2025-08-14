//
//  JWTRepository.swift
//  Domain
//
//  Created by 신동규 on 8/14/25.
//

public protocol PJWTRepository {
    func getTokens() -> AuthTokensEntity?
}
