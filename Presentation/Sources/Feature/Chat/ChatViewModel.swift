//
//  ChatViewModel.swift
//  Presentation
//
//  Created by 신동규 on 8/22/25.
//

import SwiftUI
import Domain
import Factory
import Combine

final class ChatViewModel: ObservableObject {
    let chatId: String
    
    @Published var me: ProfileEntitiy?
    @Published var text: String = ""
    @Published var messages: [MessagePresentation] = []
    @Published var loading = false
    
    var pagination: PaginationEntity?
    
    private var participants: [ProfileEntitiy] = []
    
    @Injected(\.chatUseCase) private var chatUseCase
    @Injected(\.contentViewModel) private var contentViewModel
    
    // 실시간 채팅 UseCase는 런타임에 생성
    private let realTimeChatUseCase: RealTimeChatUseCase
    
    private var cancellables = Set<AnyCancellable>()
    
    init(chatId: String) {
        self.chatId = chatId
        self.realTimeChatUseCase = .init(chatId: chatId, realTimeChatRepository: Container.shared.realTimeChatRepository())
        
        bind()
        realTimeChatUseCase.connect()
    }
    
    deinit {
        cleanup()
    }
    
    func cleanup() {
        realTimeChatUseCase.leaveChat()
        realTimeChatUseCase.dismiss()
        cancellables.removeAll()
    }
    
    @MainActor
    func fetchMessages() async throws {
        guard loading == false else { return }
        if pagination?.hasMore == false {
            return
        }
        
        loading = true
        defer { loading = false }
        
        let result = try await chatUseCase.getChat(chatId: chatId, cursor: pagination?.nextCursor)
        let chat = result.0
        participants = chat.participants
        
        let messagePresentations = chat.messages.compactMap { message in
            MessagePresentation(message: message, participants: participants)
        }
        
        messages.append(contentsOf: messagePresentations)
        pagination = result.1
    }
    
    @MainActor
    func sendMessage() async throws {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let messageText = text
        text = ""
        
        // 기존 API 호출
        let message = try await chatUseCase.sendMessage(chatId: chatId, text: messageText)
        // 실시간으로도 전송
        realTimeChatUseCase.sendMessage(message: message)
    }
    
    private func bind() {
        contentViewModel
            .$me
            .receive(on: DispatchQueue.main)
            .assign(to: &$me)
        
        $messages
            .sink { [weak self] _ in
                Task {
                    guard let self else { return }
                    try await self.chatUseCase.updateReadInfo(chatId: self.chatId)
                }
            }
            .store(in: &cancellables)
        
        realTimeChatUseCase
            .listenForConnection()
            .filter { $0 }
            .first()
            .sink { [weak self] _ in
                self?.realTimeChatUseCase.joinChat()
            }
            .store(in: &cancellables)
        
        realTimeChatUseCase
            .listenMessage()
            .compactMap { [weak self] message in 
                // ❌ 수정: weak self로 참조 캡처
                guard let self = self else { return nil }
                return MessagePresentation(message: message, participants: self.participants)
            }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] messagePresentation in
                self?.messages.insert(messagePresentation, at: 0)
            }
            .store(in: &cancellables)
    }
}
