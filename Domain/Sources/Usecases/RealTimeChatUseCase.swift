//
//  RealTimeChatUseCase.swift
//  Domain
//
//  Created by 신동규 on 8/23/25.
//

import Foundation
import Combine

public final class RealTimeChatUseCase {
    let chatId: String
    let realTimeChatRepository: PRealTimeChatRepository
    
    public init(chatId: String, realTimeChatRepository: PRealTimeChatRepository) {
        self.chatId = chatId
        self.realTimeChatRepository = realTimeChatRepository
        
        realTimeChatRepository.joinChat(chatId: chatId)
    }
    
    deinit {
        realTimeChatRepository.leaveChat(chatId: chatId)
    }
    
    public func sendMessage(message: MessageEntity) {
        realTimeChatRepository.sendMessage(chatId: chatId, message: message)
    }
    
    public func listenMessage() -> AnyPublisher<MessageEntity, Never> {
        realTimeChatRepository.listenMessage()
    }
}
