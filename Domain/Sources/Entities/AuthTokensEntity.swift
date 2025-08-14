//
//  AuthTokensEntity.swift
//  Domain
//
//  Created by 신동규 on 8/14/25.
//

public struct AuthTokensEntity {
    public let accessToken: String
    public let refreshToken: String
    
    public init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
