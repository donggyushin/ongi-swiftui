//
//  MockChatRepository.swift
//  Presentation
//
//  Created by 신동규 on 8/22/25.
//

import Domain

final class MockChatRepository: PChatRepository {
    func getChats() async throws -> [Domain.ChatEntity] {
        []
    }
}
