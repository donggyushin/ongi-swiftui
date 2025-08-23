//
//  ChatRepository.swift
//  DataSource
//
//  Created by 신동규 on 8/22/25.
//

import Domain

public final class ChatRepository: PChatRepository {
    let chatRemoteDataStore = ChatRemoteDataSource()
    
    public init() { }
    
    public func getChats() async throws -> [ChatEntity] {
        return try await chatRemoteDataStore.getChats()
    }
    
    public func generateChat(profileId: String) async throws -> ChatEntity {
        return try await chatRemoteDataStore.generateChat(profileId: profileId)
    }
    
    public func getChat(chatId: String, limit: Int, cursor: String?) async throws -> (ChatEntity, PaginationEntity) {
        return try await chatRemoteDataStore.getChat(chatId: chatId, limit: limit, cursor: cursor)
    }
    
    public func sendMessage(chatId: String, text: String) async throws -> MessageEntity {
        return try await chatRemoteDataStore.sendMessage(chatId: chatId, text: text)
    }
}
