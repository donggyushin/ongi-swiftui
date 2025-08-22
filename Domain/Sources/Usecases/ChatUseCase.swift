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
    
    public func generateChat(profileId: String) async throws -> ChatEntity {
        return try await chatRepository.generateChat(profileId: profileId)
    }
    
    public func getChat(chatId: String, limit: Int = 20, cursor: String?) async throws -> (ChatEntity, PaginationEntity) {
        return try await chatRepository.getChat(chatId: chatId, limit: limit, cursor: cursor)
    }
}
