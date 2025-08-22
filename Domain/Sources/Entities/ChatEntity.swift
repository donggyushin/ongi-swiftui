//
//  ChatEntity.swift
//  Domain
//
//  Created by 신동규 on 8/22/25.
//

import Foundation

public struct ChatEntity {
    public let id: String
    public let participantsIds: [String]
    public let messages: [MessageEntity]
    public let messageReadInfos: [MessageReadInfoEntity]
    public let createdAt: Date
    public let updatedAt: Date
    public let participants: [ProfileEntitiy]
    
    public init(id: String, participantsIds: [String], messages: [MessageEntity], messageReadInfos: [MessageReadInfoEntity], createdAt: Date, updatedAt: Date, participants: [ProfileEntitiy]) {
        self.id = id
        self.participantsIds = participantsIds
        self.messages = messages
        self.messageReadInfos = messageReadInfos
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.participants = participants
    }
}
