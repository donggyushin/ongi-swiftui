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
        
        let pathComponents = urlScheme.pathComponents
        
        // ongi://profiles/:profileId 형태의 URL 파싱
        if pathComponents.count >= 3 && pathComponents[1] == "profiles" {
            let profileId = pathComponents[2]
            navigationManager?.append(.profileDetail(profileId))
        }
        
        // ongi://profiles/like 형태의 URL 파싱
        if urlScheme.absoluteString == "ongi://profiles/like" {
            navigationManager?.append(.profileListLikeMe)
        }
        
        // ongi://chats/:chatId 형태의 URL 파싱
        if pathComponents.count >= 3 && pathComponents[1] == "chats" {
            let chatId = pathComponents[2]
            navigationManager?.append(.chat(chatId))
        }
    }
}
