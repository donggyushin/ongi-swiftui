//
//  MockChatRepository.swift
//  Presentation
//
//  Created by 신동규 on 8/22/25.
//

import Domain

final class MockChatRepository: PChatRepository {
    func getChats() async throws -> [ChatEntity] {
        // Generate 5-8 mock chats with realistic conversation data
        let chatCount = Int.random(in: 5...8)
        return MockDataGenerator.shared.generateRandomChats(count: chatCount)
    }
}
