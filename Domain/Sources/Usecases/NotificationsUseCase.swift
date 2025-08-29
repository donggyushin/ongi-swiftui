//
//  NotificationsUseCase.swift
//  Domain
//
//  Created by 신동규 on 8/29/25.
//

import Foundation

public final class NotificationsUseCase {
    let notificationsRepository: PNotificationsRepository
    
    public init(notificationsRepository: PNotificationsRepository) {
        self.notificationsRepository = notificationsRepository
    }
    
    public func getNotifications(cursorId: String?) async throws -> NotificationsEntity {
        try await notificationsRepository.getNotifications(limit: 50, cursorId: cursorId)
    }
}
