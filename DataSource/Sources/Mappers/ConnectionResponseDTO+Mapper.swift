//
//  ConnectionResponseDTO+Mapper.swift
//  DataSource
//
//  Created by 신동규 on 8/17/25.
//

import Domain

extension ConnectionResponseDTO {
    func toDomainEntity() -> ConnectionEntity {
        return .init(
            profiles: profiles.compactMap { $0.toDomainEntity() },
            newProfileIds: newProfileIds,
            count: count,
            limit: limit
        )
    }
}
