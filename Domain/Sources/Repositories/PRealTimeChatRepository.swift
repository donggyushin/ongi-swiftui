//
//  PRealTimeChatRepository.swift
//  Domain
//
//  Created by 신동규 on 8/23/25.
//

import Foundation
import Combine

public protocol PRealTimeChatRepository {
    func listenForConnection() -> AnyPublisher<Bool, Never>
    func joinChat(chatId: String)
    func leaveChat(chatId: String)
    func sendMessage(chatId: String, message: MessageEntity)
    func listenMessage() -> AnyPublisher<MessageEntity, Never>
}
