//
//  RealTimeChatRepository.swift
//  DataSource
//
//  Created by 신동규 on 8/23/25.
//

import Domain
import Combine
import Foundation

public final class RealTimeChatRepository: PRealTimeChatRepository {
    
    let socketRemoteDataSource: PSocketRemoteDataSource
    
    let messageSubject: PassthroughSubject<MessageEntity, Never> = .init()
    
    private var cancellables: Set<AnyCancellable> = []
    
    public init(
        socketRemoteDataSource: PSocketRemoteDataSource
    ) {
        self.socketRemoteDataSource = socketRemoteDataSource
        
        socketRemoteDataSource.connect()
    }
    
    deinit {
        socketRemoteDataSource.disconnect()
    }
    
    public func listenForConnection() -> AnyPublisher<Bool, Never> {
        socketRemoteDataSource.listenForConnection()
    }
    
    public func joinChat(chatId: String) {
        socketRemoteDataSource.emit(event: "join-chat", data: chatId)
    }
    
    public func leaveChat(chatId: String) {
        socketRemoteDataSource.emit(event: "leave-chat", data: chatId)
    }
    
    public func sendMessage(chatId: String, message: MessageEntity) {
        
        let data: [String: Any] = [
            "chatId": chatId,
            "message": MessageResponseDTO.generate(from: message).toJSON()
        ]
        
        socketRemoteDataSource.emit(event: "send-message", data: data)
    }
    
    public func listenMessage() -> AnyPublisher<MessageEntity, Never> {
        
        struct ListenDTO: Codable {
            let chatId: String
            let message: MessageResponseDTO
        }
        
        socketRemoteDataSource
            .listen(event: "message", type: ListenDTO.self)
            .sink { [weak self] message in
                if let message = message.message.toDomainEntity() {
                    self?.messageSubject.send(message)
                }
            }
            .store(in: &cancellables)
        
        return messageSubject.eraseToAnyPublisher()
    }
}
