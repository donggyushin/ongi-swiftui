//
//  SettingViewModel.swift
//  Presentation
//
//  Created by 신동규 on 8/21/25.
//

import Domain
import Combine
import SwiftUI
import Factory

final class SettingViewModel: ObservableObject {
    
    @Injected(\.contentViewModel) private var contentViewModel
    
    @Published var me: ProfileEntitiy?
    
    init() {
        bind()
    }
    
    func bind() {
        contentViewModel
            .$me
            .receive(on: DispatchQueue.main)
            .assign(to: &$me)
    }
}
