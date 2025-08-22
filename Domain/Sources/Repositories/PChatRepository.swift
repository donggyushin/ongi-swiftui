//
//  PChatRepository.swift
//  Domain
//
//  Created by 신동규 on 8/22/25.
//

public protocol PChatRepository {
    func getChats() async throws -> [ChatEntity]
    func generateChat(profileId: String) async throws -> ChatEntity
    func getChat(chatId: String) async throws -> (ChatEntity, PaginationEntity)
}
