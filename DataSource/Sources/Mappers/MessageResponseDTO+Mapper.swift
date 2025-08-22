//
//  MessageResponseDTO+Mapper.swift
//  DataSource
//
//  Created by 신동규 on 8/22/25.
//

import Domain
import Foundation

extension MessageResponseDTO {
    func toDomainEntity() -> MessageEntity? {
        guard let createdAt = dateFormatter.date(from: createdAt),
              let updatedAt = dateFormatter.date(from: updatedAt) else { return nil }
        
        return .init(
            id: id,
            writerProfileId: writerProfileId,
            text: text,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
