//
//  MessageResponseDTO.swift
//  DataSource
//
//  Created by 신동규 on 8/22/25.
//

public struct MessageResponseDTO: Codable {
    public let id: String
    public let writerProfileId: String
    public let text: String
    public let createdAt: String
    public let updatedAt: String
    public let messageType: String?
}
