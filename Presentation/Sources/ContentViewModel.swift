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
    
    public init(
        container: Container
    ) {
        self.container = container
        self.profileUseCase = container.profileUseCase()
        self.loginViewModel = container.loginViewModel()
        
        bind()
    }
    
    func getMe() {
        Task { @MainActor in
            me = try await profileUseCase.getMe()
            loading = false
        }
    }
    
    private func bind() {
        $me
            .receive(on: DispatchQueue.main)
            .sink { [weak self] profile in
                withAnimation {
                    self?.isLogin = profile != nil
                    
                    if let profile {
                        self?.onboarding = profile.isCompleted == false
                    } else {
                        self?.onboarding = false
                    }
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
