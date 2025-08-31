//
//  URLSchemeManager.swift
//  ongi-swiftui
//
//  Created by 신동규 on 8/18/25.
//

import Foundation
import Presentation

let urlSchemeManager = URLSchemeManager.shared

final class URLSchemeManager {
    static let shared = URLSchemeManager()
    
    private init() {}
    
    func implement(_ urlScheme: URL) {
        guard urlScheme.scheme == "ongi" else { return }
        
        guard let host = urlScheme.host else { return }
        let path = urlScheme.path
        
        // ongi://profiles/like 형태의 URL 파싱
        if urlScheme.absoluteString == "ongi://profiles/like" {
            navigationManager?.append(.profileListLikeMe)
        } else if host == "profiles" && !path.isEmpty {
            // ongi://profiles/:profileId 형태의 URL 파싱
            let profileId = String(path.dropFirst()) // "/" 제거
            navigationManager?.append(.profileDetail(profileId))
        } else if host == "chats" && !path.isEmpty {
            // ongi://chats/:chatId 형태의 URL 파싱
            let chatId = String(path.dropFirst()) // "/" 제거
            
            if let currentChatId = navigationManager?.currentChatId, currentChatId == chatId {
                return
            }
            
            navigationManager?.append(.chat(chatId))
        }
    }
}
