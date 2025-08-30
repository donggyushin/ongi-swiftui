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
    @Published var notifications: NotificationsEntity = .init(notifications: [], nextCursor: nil, hasMore: true)
    
    @Injected(\.notificationsUseCase) private var notificationsUseCase
    
    public init() { }
    
    @MainActor
    func tapNotification(_ notification: NotificationEntity) async throws {
        guard loading == false else { return }
        loading = true
        defer { loading = false }
        
        if let url = notification.urlScheme {
            await UIApplication.shared.open(url)
        }
        
        try await notificationsUseCase.read(notificationId: notification.id)
        
        guard let index = notifications.notifications.firstIndex(where: { $0.id == notification.id }) else { return }
        notifications.notifications[index].isRead = true 
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
        
    }
}
