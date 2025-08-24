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
    
    let locationManager = LocationManager()
    
    @Published var loading = true
    
    @Published var me: ProfileEntitiy?
    @Published public var isLogin = false
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
    
    @MainActor
    func getMe() async throws {
        loading = true
        defer { loading = false }
        me = try await profileUseCase.getMe()
        onboarding = me?.isCompleted != true
        
        if me?.isCompleted == true {
            locationManager.requestLocation()
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
                Task {
                    try await self?.getMe()
                }
            }
            .store(in: &cancellables)
        
        locationManager
            .$location
            .compactMap { $0 }
            .sink { location in
                print(location)
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
