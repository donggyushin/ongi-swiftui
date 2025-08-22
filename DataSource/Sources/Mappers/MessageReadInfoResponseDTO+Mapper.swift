//
//  MessageReadInfoResponseDTO+Mapper.swift
//  DataSource
//
//  Created by 신동규 on 8/22/25.
//

import Foundation
import Domain

extension MessageReadInfoResponseDTO {
    func toDomainEntity() -> MessageReadInfoEntity? {
        
        guard let dateInfoUserViewedRecently = dateFormatter.date(from: dateInfoUserViewedRecently) else { return nil }
        
        return .init(
            id: id,
            profileId: profileId,
            dateInfoUserViewedRecently: dateInfoUserViewedRecently
        )
    }
}
