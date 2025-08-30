//
//  MockChatRepository.swift
//  Presentation
//
//  Created by 신동규 on 8/22/25.
//

import Domain
import Foundation

final class MockChatRepository: PChatRepository {
    func sendMessage(chatId: String, text: String) async throws -> MessageEntity {
        return .init(
            id: chatId,
            writerProfileId: UUID().uuidString,
            text: text,
            createdAt: Date(),
            updatedAt: Date()
        )
    }
    
    func getChats() async throws -> [ChatEntity] {
        // Generate 5-8 mock chats with realistic conversation data
        try await Task.sleep(for: .seconds(1))
        let chatCount = Int.random(in: 5...8)
        return MockDataGenerator.shared.generateRandomChats(count: chatCount)
    }
    
    func generateChat(profileId: String) async throws -> ChatEntity {
        try await Task.sleep(for: .seconds(1))
        return MockDataGenerator.shared.generateRandomChat()
    }
    
    func getChat(chatId: String, limit: Int, cursor: String?) async throws -> (ChatEntity, PaginationEntity) {
        try await Task.sleep(for: .seconds(1))
        let chat = MockDataGenerator.shared.generateRandomChat(id: chatId)
        let pagination = PaginationEntity(limit: limit, hasMore: false, nextCursor: chat.messages.last?.id)
        return (chat, pagination)
    }
    
    func updateReadInfo(chatId: String, date: Date) async throws {
        
    }
    
    func leaveChat(chatId: String) async throws { }
}
