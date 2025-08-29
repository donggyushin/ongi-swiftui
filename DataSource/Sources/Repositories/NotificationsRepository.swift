//
//  NotificationsRepository.swift
//  DataSource
//
//  Created by 신동규 on 8/29/25.
//

import Foundation
import Domain

public final class NotificationsRepository: PNotificationsRepository {
    
    public func read(notificationId: String) async throws {
        try await notificationsRemoteDataSource.read(notificationId: notificationId)
    }
    
    public func unreadCount() async throws -> Int {
        try await notificationsRemoteDataSource.unreadCount()
    }
    
    public func getNotifications(limit: Int, cursorId: String?) async throws -> NotificationsEntity {
        try await notificationsRemoteDataSource.getNotifications(limit: limit, cursorId: cursorId)
    }
    
    let notificationsRemoteDataSource = NotificationsRemoteDataSource()
    
    public init() { }
}
