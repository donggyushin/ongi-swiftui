//
//  PaginationResponseDTO+Mapper.swift
//  DataSource
//
//  Created by 신동규 on 8/22/25.
//

import Domain

extension PaginationResponseDTO {
    func toDomainEntity() -> PaginationEntity {
        return .init(limit: limit, hasMore: hasMore, nextCursor: nextCursor)
    }
}
