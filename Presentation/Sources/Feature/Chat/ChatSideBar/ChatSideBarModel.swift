//
//  ChatSideBarModel.swift
//  Presentation
//
//  Created by 신동규 on 8/31/25.
//

import Factory
import Domain
import SwiftUI
import Combine

final class ChatSideBarModel: ObservableObject {
    
    @Published var myId: String?
    
    @Injected(\.contentViewModel) private var contentViewModel
    
    init() {
        contentViewModel
            .$me
            .map { $0?.id }
            .receive(on: DispatchQueue.main)
            .assign(to: &$myId)
    }
}
