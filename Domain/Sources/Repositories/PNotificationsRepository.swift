//
//  PNotificationsRepository.swift
//  Domain
//
//  Created by 신동규 on 8/29/25.
//

import Foundation

public protocol PNotificationsRepository {
    func getNotifications(limit: Int, cursorId: String?) async throws -> NotificationsEntity
}
