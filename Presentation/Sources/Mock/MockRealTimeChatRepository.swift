//
//  MockRealTimeChatRepository.swift
//  Presentation
//
//  Created by 신동규 on 8/23/25.
//

import Foundation
import Combine
import Domain

public class MockRealTimeChatRepository: PRealTimeChatRepository {
    private let connectionSubject = CurrentValueSubject<Bool, Never>(true)
    private let messageSubject = PassthroughSubject<MessageEntity, Never>()
    
    public init() {}
    
    public func listenForConnection() -> AnyPublisher<Bool, Never> {
        return connectionSubject.eraseToAnyPublisher()
    }
    
    public func joinChat(chatId: String) {
        print("[Mock] Joined chat: \(chatId)")
    }
    
    public func leaveChat(chatId: String) {
        print("[Mock] Left chat: \(chatId)")
    }
    
    public func sendMessage(chatId: String, message: MessageEntity) {
        print("[Mock] Sent message to \(chatId): \(message.text)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.messageSubject.send(message)
        }
    }
    
    public func listenMessage() -> AnyPublisher<MessageEntity, Never> {
        return messageSubject.eraseToAnyPublisher()
    }
    
    public func simulateIncomingMessage(_ message: MessageEntity) {
        messageSubject.send(message)
    }
    
    public func simulateConnectionChange(isConnected: Bool) {
        connectionSubject.send(isConnected)
        print("[Mock] Connection status changed to: \(isConnected)")
    }
}