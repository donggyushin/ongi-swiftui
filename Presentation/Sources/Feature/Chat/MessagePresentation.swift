//
//  MessagePresentation.swift
//  Presentation
//
//  Created by 신동규 on 8/23/25.
//

import Domain
import Foundation

struct MessagePresentation: Equatable {
    
    static func == (lhs: MessagePresentation, rhs: MessagePresentation) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: String
    let writer: ProfileEntitiy
    let text: String
    let createdAt: Date
    let updatedAt: Date
    
    init(message: MessageEntity, participants: [ProfileEntitiy]) {
        let writer: ProfileEntitiy = participants.first(
            where: {
                $0.id == message.writerProfileId
            }) ?? .init(
                id: "",
                nickname: "알 수 없음",
                images: [],
                qnas: [],
                isNew: false,
                isLikedByMe: false,
                createdAt: Date(),
                updatedAt: Date()
            )
        
        self.id = message.id
        self.writer = writer
        self.text = message.text
        self.createdAt = message.createdAt
        self.updatedAt = message.updatedAt
    }
}

