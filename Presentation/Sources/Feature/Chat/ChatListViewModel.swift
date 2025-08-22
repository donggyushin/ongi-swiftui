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
    
    @Published var myId: String?
    
    @Injected(\.chatUseCase) private var chatUseCase
    @Injected(\.contentViewModel) private var contentViewModel
    
    init() {
        bind()
    }
    
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
    
    private func bind() {
        contentViewModel
            .$me
            .map { $0?.id }
            .receive(on: DispatchQueue.main)
            .assign(to: &$myId)
    }
}
