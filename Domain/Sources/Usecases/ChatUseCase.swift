//
//  ChatUseCase.swift
//  Domain
//
//  Created by 신동규 on 8/22/25.
//

public final class ChatUseCase {
    let chatRepository: PChatRepository
    
    public init(chatRepository: PChatRepository) {
        self.chatRepository = chatRepository
    }
    
    public func getChats() async throws -> [ChatEntity] {
        return try await chatRepository.getChats()
    }
}
