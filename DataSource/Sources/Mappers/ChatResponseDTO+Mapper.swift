//
//  ChatResponseDTO+Mapper.swift
//  DataSource
//
//  Created by 신동규 on 8/22/25.
//

import Domain
import Foundation

extension ChatResponseDTO {
    func toDomainEntity() -> ChatEntity? {
        guard let createdAt = dateFormatter.date(from: createdAt),
              let updatedAt = dateFormatter.date(from: updatedAt) else { return nil }
        
        let mappedMessages = messages.compactMap { $0.toDomainEntity() }
        let mappedMessageReadInfos = messageReadInfos.compactMap { $0.toDomainEntity() }
        let mappedParticipants = participants.compactMap { $0.toDomainEntity() }
        
        return .init(
            id: id,
            participantsIds: participantsIds,
            messages: mappedMessages,
            messageReadInfos: mappedMessageReadInfos,
            createdAt: createdAt,
            updatedAt: updatedAt,
            participants: mappedParticipants
        )
    }
}