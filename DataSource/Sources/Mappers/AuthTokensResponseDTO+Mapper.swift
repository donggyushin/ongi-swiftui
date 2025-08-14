//
//  AuthTokensResponseDTO+Mapper.swift
//  Domain
//
//  Created by 신동규 on 8/14/25.
//

import Domain

extension AuthTokensResponseDTO {
    func toDomainEntity() -> AuthTokensEntity {
        return .init(accessToken: accessToken, refreshToken: refreshToken)
    }
}
