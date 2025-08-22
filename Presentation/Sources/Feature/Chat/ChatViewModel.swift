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
    
    @Published var participants: [ProfileEntitiy] = []
    @Published var messages: [MessageEntity] = []
    @Published var loading = false
    
    var pagination: PaginationEntity?
    
    @Injected(\.chatUseCase) private var chatUseCase
    
    init(chatId: String) {
        self.chatId = chatId
    }
    
    @MainActor
    func fetchMessages() async throws {
        loading = true
        defer { loading = false }
        
        let result = try await chatUseCase.getChat(chatId: chatId, cursor: pagination?.nextCursor)
        participants = result.0.participants
        messages = result.0.messages
        
        pagination = result.1
    }
}
