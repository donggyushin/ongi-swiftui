//
//  MockChatRepository.swift
//  Presentation
//
//  Created by 신동규 on 8/22/25.
//

import Domain
import Foundation

final class MockChatRepository: PChatRepository {
    func getChats() async throws -> [ChatEntity] {
        // Generate 5-8 mock chats with realistic conversation data
        let chatCount = Int.random(in: 5...8)
        return MockDataGenerator.shared.generateRandomChats(count: chatCount)
    }
    
    func getChat(id: String) async throws -> (ChatEntity, PaginationEntity) {
        let chat = MockDataGenerator.shared.generateRandomChat(id: id)
        let pagination = PaginationEntity(
            limit: chat.messages.count,
            hasMore: false,
            nextCursor: chat.messages.last?.id
        )
        return (chat, pagination)
    }
}
