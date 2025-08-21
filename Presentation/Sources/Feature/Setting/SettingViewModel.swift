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
    @Injected(\.authUseCase) private var authUseCase
    
    @Published var me: ProfileEntitiy?
    
    init() {
        bind()
    }
    
    @MainActor
    func logout() async throws {
        contentViewModel.isLogin = false
        contentViewModel.me = nil
        try await Task.sleep(for: .seconds(1))
        authUseCase.logout()
        navigationManager?.popToRoot()
    }
    
    func bind() {
        contentViewModel
            .$me
            .receive(on: DispatchQueue.main)
            .assign(to: &$me)
    }
}
