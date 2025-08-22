//
//  ChatResponseDTO.swift
//  DataSource
//
//  Created by 신동규 on 8/22/25.
//

struct ChatResponseDTO: Decodable {
    let id: String
    let participantsIds: [String]
    let messages: [MessageResponseDTO]
    let messageReadInfos: [MessageReadInfoResponseDTO]
    let createdAt: String
    let updatedAt: String
    let participants: [ProfileResponseDTO]
}