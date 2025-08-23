//
//  MessagePresentation+Mapper.swift
//  Presentation
//
//  Created by 신동규 on 8/23/25.
//

import Domain

extension MessagePresentation {
    func toDomainEntity() -> MessageEntity {
        return .init(
            id: id,
            writerProfileId: writer.id,
            text: text,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
