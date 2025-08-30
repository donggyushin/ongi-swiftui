//
//  NotificationsRemoteDataSource.swift
//  DataSource
//
//  Created by 신동규 on 8/29/25.
//

import Foundation
import Domain

final class NotificationsRemoteDataSource {
    let networkManager = NetworkManager.shared
    
    func getNotifications(limit: Int, cursorId: String?) async throws -> NotificationsEntity {
        var url = "\(ongiExpressUrl)notifications?limit=\(limit)"
        if let cursorId {
            url += "&cursorId=\(cursorId)"
        }
        
        struct Response: Decodable {
            let notifications: [NotificationResponseDTO]
            let nextCursor: String?
            let hasMore: Bool
            
            func toDomain() -> NotificationsEntity {
                return .init(
                    notifications: notifications.compactMap { $0.toEntity() },
                    nextCursor: nextCursor,
                    hasMore: hasMore
                )
            }
        }
        
        let response: APIResponse<Response> = try await networkManager.request(url: url)
        
        if let domain = response.data?.toDomain() {
            return domain
        } else {
            throw AppError.networkError(.invalidResponse)
        }
    }
    
    func unreadCount() async throws -> Int {
        let url = "\(ongiExpressUrl)notifications/unread/count"
        struct Response: Decodable {
            let count: Int
        }
        let response: APIResponse<Response> = try await networkManager.request(url: url)
        return response.data?.count ?? 0
    }
    
    func read(notificationId: String) async throws {
        let url = "\(ongiExpressUrl)notifications/\(notificationId)/read"
        
        let _: APIResponse<Empty> = try await networkManager.request(url: url, method: .patch)
    }
    
    func readAll() async throws {
        let url = "\(ongiExpressUrl)notifications/read-all"
        let _: APIResponse<Empty> = try await networkManager.request(url: url, method: .patch)
    }
}
