//
//  NotificationResponseDTO.swift
//  DataSource
//
//  Created by 신동규 on 8/29/25.
//

import Foundation
import Domain

public struct NotificationResponseDTO: Codable {
    public let id: String
    public let recipientId: String
    public let type: String
    public let title: String
    public let message: String
    public let isRead: Bool
    public let data: [String: String]?
    public let createdAt: String
    public let updatedAt: String
    
    public init(id: String, recipientId: String, type: String, title: String, message: String, isRead: Bool, data: [String: String]?, createdAt: String, updatedAt: String) {
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

extension NotificationResponseDTO {
    public func toEntity() -> NotificationEntity {
        let dateFormatter = ISO8601DateFormatter()
        let createdDate = dateFormatter.date(from: createdAt) ?? Date()
        let updatedDate = dateFormatter.date(from: updatedAt) ?? Date()
        
        var entityData: [String: Any]?
        if let data = data {
            entityData = data
        }
        
        return NotificationEntity(
            id: id,
            recipientId: recipientId,
            type: type,
            title: title,
            message: message,
            isRead: isRead,
            data: entityData,
            createdAt: createdDate,
            updatedAt: updatedDate
        )
    }
}