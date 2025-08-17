//
//  ContentViewModel.swift
//  Presentation
//
//  Created by 신동규 on 8/14/25.
//

import Combine
import Domain
import Foundation
import Factory
import SwiftUI

public final class ContentViewModel: ObservableObject {
    
    let container: Container
    let profileUseCase: ProfileUseCase
    let loginViewModel: LoginViewModel
    
    @Published var loading = true
    
    @Published var me: ProfileEntitiy?
    @Published var isLogin = false
    @Published var onboarding = false
    
    private var cancellables = Set<AnyCancellable>()
    
    public init() {
        self.container = Container.shared
        self.profileUseCase = container.profileUseCase()
        self.loginViewModel = .init()
        
        bind()
    }
    
    func getMe() {
        Task { @MainActor in
            me = try await profileUseCase.getMe()
            loading = false
            onboarding = me?.isCompleted != true
        }
    }
    
    private func bind() {
        $me
            .receive(on: DispatchQueue.main)
            .sink { [weak self] profile in
                withAnimation {
                    self?.isLogin = profile != nil
                }
            }
            .store(in: &cancellables)
        
        loginViewModel
            .loginSuccessSubject
            .sink { [weak self] in
                self?.getMe()
            }
            .store(in: &cancellables)
    }
}
