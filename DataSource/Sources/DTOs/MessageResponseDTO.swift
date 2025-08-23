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
    
    public init(id: String, writerProfileId: String, text: String, createdAt: String, updatedAt: String) {
        self.id = id
        self.writerProfileId = writerProfileId
        self.text = text
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
