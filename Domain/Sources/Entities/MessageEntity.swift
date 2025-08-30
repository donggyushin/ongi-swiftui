//
//  MessageEntity.swift
//  Domain
//
//  Created by 신동규 on 8/22/25.
//

import Foundation

public struct MessageEntity {
    public let id: String
    public let writerProfileId: String
    public let text: String
    public let createdAt: Date
    public let updatedAt: Date
    public var messageType: MessageType?
    
    public init(id: String, writerProfileId: String, text: String, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.writerProfileId = writerProfileId
        self.text = text
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension MessageEntity {
    public enum MessageType {
        case leaveChat
    }
}
