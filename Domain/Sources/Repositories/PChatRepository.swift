//
//  PChatRepository.swift
//  Domain
//
//  Created by 신동규 on 8/22/25.
//

public protocol PChatRepository {
    func getChats() async throws -> [ChatEntity]
    func generateChat(profileId: String) async throws -> ChatEntity
    func getChat(chatId: String, limit: Int, cursor: String?) async throws -> (ChatEntity, PaginationEntity)
}
