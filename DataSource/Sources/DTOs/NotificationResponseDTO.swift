//
//  NotificationResponseDTO.swift
//  DataSource
//
//  Created by 신동규 on 8/29/25.
//

import Foundation
import Domain

struct NotificationResponseDTO: Codable {
    let id: String
    let recipientId: String
    let type: String
    let title: String
    let message: String
    let isRead: Bool
    let data: Data?
    let urlScheme: String?
    let createdAt: String
    let updatedAt: String
}

extension NotificationResponseDTO {
    public func toEntity() -> NotificationEntity {
        let createdDate = dateFormatter.date(from: createdAt) ?? Date()
        let updatedDate = dateFormatter.date(from: updatedAt) ?? Date()
        
        return NotificationEntity(
            id: id,
            recipientId: recipientId,
            type: type,
            title: title,
            message: message,
            isRead: isRead,
            data: data?.toDomain(),
            urlScheme: .init(string: urlScheme ?? ""),
            createdAt: createdDate,
            updatedAt: updatedDate
        )
    }
}

extension NotificationResponseDTO {
    public struct Data: Codable {
        let type: String?
        let likerNickname: String?
        let likerProfileId: String?
        let likerProfile: ProfileResponseDTO?
        
        func toDomain() -> NotificationEntity.Data? {
            return .init(
                type: type,
                likerNickname: likerNickname,
                likerProfileId: likerProfileId,
                likerProfile: likerProfile?.toDomainEntity()
            )
        }
    }
}
