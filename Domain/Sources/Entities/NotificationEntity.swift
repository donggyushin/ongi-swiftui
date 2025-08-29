//
//  NotificationEntity.swift
//  Domain
//
//  Created by 신동규 on 8/29/25.
//

import Foundation

public struct NotificationEntity {
    public let id: String
    public let recipientId: String
    public let type: String
    public let title: String
    public let message: String
    public let isRead: Bool
    public let data: [String: Any]?
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(id: String, recipientId: String, type: String, title: String, message: String, isRead: Bool, data: [String : Any]?, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.recipientId = recipientId
        self.type = type
        self.title = title
        self.message = message
        self.isRead = isRead
        self.data = data
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
