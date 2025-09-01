//
//  NavigationManager.swift
//  Presentation
//
//  Created by 신동규 on 8/18/25.
//

import Combine
import SwiftUI

public var navigationManager: NavigationManager?

public final class NavigationManager {
    @Binding var navigationPath: [Navigation]
    
    public init(navigationPath: Binding<[Navigation]>) {
        self._navigationPath = navigationPath
    }
    
    public var currentChatId: String? {
        return navigationPath.last?.chatId
    }
    
    public func append(_ navigation: Navigation) {
        self.navigationPath.append(navigation)
    }
    
    public func pop() {
        if navigationPath.isEmpty == false {
            navigationPath.removeLast()
        }
    }
    
    public func popToRoot() {
        navigationPath.removeAll()
    }
}
