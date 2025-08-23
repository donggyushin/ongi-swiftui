//
//  PChatRepository.swift
//  Domain
//
//  Created by 신동규 on 8/22/25.
//

import Foundation

public protocol PChatRepository {
    func getChats() async throws -> [ChatEntity]
    func generateChat(profileId: String) async throws -> ChatEntity
    func getChat(chatId: String, limit: Int, cursor: String?) async throws -> (ChatEntity, PaginationEntity)
    func sendMessage(chatId: String, text: String) async throws -> MessageEntity
    func updateReadInfo(chatId: String, date: Date) async throws
}
