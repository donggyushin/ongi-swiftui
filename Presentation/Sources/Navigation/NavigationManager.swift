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
}
