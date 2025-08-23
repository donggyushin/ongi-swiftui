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
    
    @Injected(\.chatUseCase) private var chatUseCase
    @Injected(\.contentViewModel) private var contentViewModel
    
    init(chatId: String) {
        self.chatId = chatId
        
        bind()
    }
    
    @MainActor
    func fetchMessages() async throws {
        if pagination?.hasMore == false {
            return
        }
        
        loading = true
        defer { loading = false }
        
        let result = try await chatUseCase.getChat(chatId: chatId, cursor: pagination?.nextCursor)
        let chat = result.0
        let participants = chat.participants
        
        let messagePresentations = chat.messages.compactMap { message in
            MessagePresentation(message: message, participants: participants)
        }
        
        messages = messagePresentations
        pagination = result.1
    }
    
    @MainActor
    func sendMessage() async throws {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        guard let me = me else { return }
        
        let messageText = text
        text = ""
        
        let newMessageEntity = try await chatUseCase.sendMessage(chatId: chatId, text: messageText)
        
        if let newMessagePresentation = MessagePresentation(message: newMessageEntity, participants: [me]) {
            messages.insert(newMessagePresentation, at: 0)
        }
    }
    
    private func bind() {
        contentViewModel
            .$me
            .receive(on: DispatchQueue.main)
            .assign(to: &$me)
    }
}
