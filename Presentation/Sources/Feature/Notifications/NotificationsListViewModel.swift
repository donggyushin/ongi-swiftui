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
