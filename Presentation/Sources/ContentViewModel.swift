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

public final class ContentViewModel: ObservableObject {
    
    let profileUseCase: ProfileUseCase
    let loginViewModel: LoginViewModel
    let profileListViewModelFactory: Factory<ProfileListViewModel>
    
    @Published var me: ProfileEntitiy?
    @Published var isLogin = false
    
    private var cancellables = Set<AnyCancellable>()
    
    public init(
        profileUseCase: ProfileUseCase,
        loginViewModel: LoginViewModel,
        profileListViewModelFactory: Factory<ProfileListViewModel>
    ) {
        self.profileUseCase = profileUseCase
        self.loginViewModel = loginViewModel
        self.profileListViewModelFactory = profileListViewModelFactory
        
        bind()
    }
    
    func getMe() {
        Task { @MainActor in
            me = try await profileUseCase.getMe()
        }
    }
    
    private func bind() {
        $me
            .map { $0 != nil }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: &$isLogin)
        
        loginViewModel
            .loginSuccessSubject
            .sink { [weak self] in
                self?.getMe()
            }
            .store(in: &cancellables)
    }
}
