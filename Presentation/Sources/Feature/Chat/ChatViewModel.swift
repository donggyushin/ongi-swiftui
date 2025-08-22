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
    
    init(chatId: String) {
        self.chatId = chatId
        
    }
}
