//
//  MessageResponseDTO.swift
//  DataSource
//
//  Created by 신동규 on 8/22/25.
//

struct MessageResponseDTO: Decodable {
    let id: String
    let writerProfileId: String
    let text: String
    let createdAt: String
    let updatedAt: String
}
