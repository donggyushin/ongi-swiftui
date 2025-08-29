//
//  NotificationEntity.swift
//  Domain
//
//  Created by 신동규 on 8/29/25.
//

import Foundation

public struct NotificationsEntity {
    public let notifications: [NotificationEntity]
    public let nextCursor: String?
    public let hasMore: Bool
    
    public init(notifications: [NotificationEntity], nextCursor: String?, hasMore: Bool) {
        self.notifications = notifications
        self.nextCursor = nextCursor
        self.hasMore = hasMore
    }
}

public struct NotificationEntity {
    public let id: String
    public let recipientId: String
    public let type: String
    public let title: String
    public let message: String
    public let isRead: Bool
    public let data: Data?
    public let urlScheme: URL?
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(id: String, recipientId: String, type: String, title: String, message: String, isRead: Bool, data: Data?, urlScheme: URL?, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.recipientId = recipientId
        self.type = type
        self.title = title
        self.message = message
        self.isRead = isRead
        self.data = data
        self.urlScheme = urlScheme
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension NotificationEntity {
    public struct Data {
        public let type: String?
        public let likerNickname: String?
        public let likerProfileId: String?
        public let likerProfile: ProfileEntitiy?
        
        public init(type: String?, likerNickname: String?, likerProfileId: String?, likerProfile: ProfileEntitiy?) {
            self.type = type
            self.likerNickname = likerNickname
            self.likerProfileId = likerProfileId
            self.likerProfile = likerProfile
        }
    }
}
