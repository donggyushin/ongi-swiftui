//
//  QnAEntity.swift
//  Domain
//
//  Created by 신동규 on 8/14/25.
//

import Foundation

public struct QnAEntity {
    public let id: String
    public let question: String
    public let answer: String
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(id: String, question: String, answer: String, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.question = question
        self.answer = answer
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
