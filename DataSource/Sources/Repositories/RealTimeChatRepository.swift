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
    
    private let socketRemoteDataSource: PSocketRemoteDataSource
    private let messageSubject: PassthroughSubject<MessageEntity, Never> = .init()
    private var cancellables: Set<AnyCancellable> = []
    private var isListeningForMessages = false
    
    public init(
        socketRemoteDataSource: PSocketRemoteDataSource
    ) {
        self.socketRemoteDataSource = socketRemoteDataSource
    }
    
    deinit {
        // Repository 해제 시 개별 구독만 정리
        // Socket 연결은 다른 Repository들이 사용할 수 있으므로 건드리지 않음
        cancellables.removeAll()
    }
    
    public func connect() {
        if !socketRemoteDataSource.isConnected {
            socketRemoteDataSource.connect()
        }
    }
    
    public func disconnect() {
        // Repository별로 구독만 정리, Socket 연결은 유지
        cancellables.removeAll()
        isListeningForMessages = false
    }
    
    public func listenForConnection() -> AnyPublisher<Bool, Never> {
        socketRemoteDataSource.listenForConnection()
    }
    
    public func joinChat(chatId: String) {
        connect()
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
        if !isListeningForMessages {
            isListeningForMessages = true
            setupMessageListener()
        }
        
        return messageSubject.eraseToAnyPublisher()
    }
    
    private func setupMessageListener() {
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
    }
}
