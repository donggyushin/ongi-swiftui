//
//  JWTRemoteDataSource.swift
//  DataSource
//
//  Created by 신동규 on 8/14/25.
//

import Foundation
import Domain

final class JWTRemoteDataSource {
    public func refreshToken(refreshToken: String) async throws -> AuthTokensEntity {
        throw NSError(domain: "JWTRemoteDataSource", code: 0, userInfo: [NSLocalizedDescriptionKey: "refreshToken not implemented yet"])
    }
}
