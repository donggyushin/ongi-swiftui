//
//  Navigation.swift
//  Presentation
//
//  Created by 신동규 on 8/18/25.
//

import Foundation

public enum Navigation: Hashable {
    case profileDetail(String)
    case profileDetailStack(String)
    case profileListLikeMe
    case setting
    case chatList
    case chat(String)
    case zoomableImage(URL)
    case notifications
}
