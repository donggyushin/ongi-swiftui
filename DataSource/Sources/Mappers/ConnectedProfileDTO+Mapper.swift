//
//  ConnectedProfileDTO+Mapper.swift
//  DataSource
//
//  Created by 신동규 on 8/19/25.
//

import Domain

extension ConnectedProfileDTO {
    func toDomainEntity() -> ConnectedProfileEntity? {
        guard let addedAt = dateFormatter.date(from: addedAt) else { return nil }
        return .init(
            profileId: profileId,
            addedAt: addedAt,
            isNew: isNew
        )
    }
}
