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
import DataSource

public final class ContentViewModel: ObservableObject {
    
    let container: Container
    let profileUseCase: ProfileUseCase
    let authUseCase: AuthUseCase
    let loginViewModel: LoginViewModel
    
    @Published var loading = true
    
    @Published var me: ProfileEntitiy?
    @Published var isLogin = false
    @Published var onboarding = false
    
    @Published var authenticationFailDialog = false
    
    private var cancellables = Set<AnyCancellable>()
    
    public init() {
        self.container = Container.shared
        self.profileUseCase = container.profileUseCase()
        self.authUseCase = container.authUseCase()
        self.loginViewModel = .init()
        
        bind()
        setupLogoutNotification()
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
    
    private func setupLogoutNotification() {
        NotificationCenter.default
            .publisher(for: .userShouldLogout)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.authenticationFailDialog = true 
            }
            .store(in: &cancellables)
    }
    
    func handleLogout() {
        // 로그아웃 처리: 사용자 정보 초기화
        authUseCase.logout()
        withAnimation {
            me = nil
            isLogin = false
            onboarding = false
            loading = false
        }
    }
}
