//
//  ChatRemoteDataSource.swift
//  DataSource
//
//  Created by 신동규 on 8/22/25.
//

import Foundation
import Domain

final class ChatRemoteDataSource {
    let networkManager = NetworkManager.shared
    
    func getChats() async throws -> [ChatEntity] {
        let url = "\(ongiExpressUrl)chats"
        struct Response: Decodable {
            let chats: [ChatResponseDTO]
        }
        
        let response: APIResponse<Response> = try await networkManager.request(url: url)
        
        if let chats = response.data?.chats.compactMap ({ $0.toDomainEntity() }) {
            return chats
        } else if let message = response.message {
            throw AppError.custom(message)
        } else {
            throw AppError.networkError(.invalidResponse)
        }
    }
    
    func getChat(chatId: String) async throws -> (ChatEntity, PaginationEntity) {
        let url = "\(ongiExpressUrl)chats/\(chatId)"
        struct DataResponse: Decodable {
            let chat: ChatResponseDTO
            let pagination: PaginationResponseDTO
        }
        
        let response: APIResponse<DataResponse> = try await networkManager.request(url: url)
        
        if let chat = response.data?.chat.toDomainEntity(), let pagination = response.data?.pagination.toDomainEntity() {
            return (chat, pagination)
        } else if let message = response.message {
            throw AppError.custom(message)
        } else {
            throw AppError.networkError(.invalidResponse)
        }
    }
    
    func generateChat(profileId: String) async throws -> ChatEntity {
        let url = "\(ongiExpressUrl)chats/\(profileId)"
        
        struct Response: Decodable {
            let chat: ChatResponseDTO
        }
        
        let response: APIResponse<Response> = try await networkManager.request(url: url, method: .post)
        
        if let chat = response.data?.chat.toDomainEntity() {
            return chat
        } else if let message = response.message {
            throw AppError.custom(message)
        } else {
            throw AppError.networkError(.invalidResponse)
        }
    }
}
