//
//  NotificationsListViewModel.swift
//  Presentation
//
//  Created by 신동규 on 8/29/25.
//

import SwiftUI
import Domain
import Combine
import Factory

public final class NotificationsListViewModel: ObservableObject {
    
    @Published var loading = false
    @Published var bigLoading = false
    @Published var notifications: NotificationsEntity = .init(notifications: [], nextCursor: nil, hasMore: true)
    @Published var unreadCount = 0
    
    @Injected(\.notificationsUseCase) private var notificationsUseCase
    
    public init() { }
    
    @MainActor
    func fetchUnreadCount() async throws {
        unreadCount = try await notificationsUseCase.unreadCount()
    }
    
    @MainActor
    func readAll() async throws {
        guard bigLoading == false else { return }
        bigLoading = true
        defer { bigLoading = false }
        
        try await notificationsUseCase.readAll()
        
        notifications.notifications = notifications.notifications.map { notification in
            var updatedNotification = notification
            updatedNotification.isRead = true
            return updatedNotification
        }
        
        try await fetchUnreadCount()
    }
    
    @MainActor
    func tapNotification(_ notification: NotificationEntity) async throws {
        guard bigLoading == false else { return }
        bigLoading = true
        defer { bigLoading = false }
        
        if let url = notification.urlScheme {
            
            if notification.urlScheme?.absoluteString == "ongi://" {
                navigationManager?.pop()
            } else {
                await UIApplication.shared.open(url)
            }
        }
        
        if notification.isRead == false {
            try await notificationsUseCase.read(notificationId: notification.id)
            
            guard let index = notifications.notifications.firstIndex(where: { $0.id == notification.id }) else { return }
            notifications.notifications[index].isRead = true
        }
        
        try await fetchUnreadCount()
    }
    
    @MainActor
    func fetchNotifications() async throws {
        guard notifications.hasMore == true else { return }
        
        guard loading == false else { return }
        loading = true
        defer { loading = false }
        
        do {
            let notifications = try await notificationsUseCase.getNotifications(cursorId: notifications.notifications.last?.id)
            self.notifications = notifications
        } catch {
            print(error)
        }
        
        try await fetchUnreadCount()
    }
}
