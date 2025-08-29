//
//  MockNotificationsRepository.swift
//  Presentation
//
//  Created by 신동규 on 8/29/25.
//

import Foundation
import Domain

final class MockNotificationsRepository: PNotificationsRepository {
    
    func readAll() async throws { }
    
    func read(notificationId: String) async throws { }
    
    func unreadCount() async throws -> Int {
        return 3
    }

    func getNotifications(limit: Int, cursorId: String?) async throws -> NotificationsEntity {
        let mockNotifications = (1...min(limit, 10)).map { index in
            NotificationEntity(
                id: "notification_\(index)",
                recipientId: "user123",
                type: "general",
                title: "알림 제목 \(index)",
                message: "이것은 \(index)번째 알림 메시지입니다.",
                isRead: index % 3 == 0,
                data: .init(type: "like", likerNickname: "아름다운다람쥐", likerProfileId: "cmeccsr2m0001qr0koyubedwr", likerProfile: MockDataGenerator.shared.generateRandomProfile()),
                urlScheme: nil,
                createdAt: Date().addingTimeInterval(-TimeInterval(index * 3600)),
                updatedAt: Date().addingTimeInterval(-TimeInterval(index * 1800))
            )
        }
        
        let hasMore = limit >= 10
        let nextCursor = hasMore ? "cursor_\(limit)" : nil
        
        return NotificationsEntity(
            notifications: mockNotifications,
            nextCursor: nextCursor,
            hasMore: hasMore
        )
    }
}
