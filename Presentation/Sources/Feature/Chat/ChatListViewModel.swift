//
//  ChatListViewModel.swift
//  Presentation
//
//  Created by 신동규 on 8/22/25.
//

import SwiftUI
import Domain
import Factory
import Combine

final class ChatListViewModel: ObservableObject {
    @Published var loading = false
    @Published var chats: [ChatEntity] = []
    @Published var error: Error?
    
    @Injected(\.chatUseCase) private var chatUseCase
    
    @MainActor
    func fetchChats() async {
        guard !loading else { return }
        
        loading = true
        error = nil
        
        do {
            chats = try await chatUseCase.getChats()
        } catch {
            self.error = error
            print("Failed to fetch chats: \(error)")
        }
        
        loading = false
    }
    
    @MainActor
    func refresh() async {
        await fetchChats()
    }
}
