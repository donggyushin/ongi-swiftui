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
    
    let container: Container
    let profileUseCase: ProfileUseCase
    let loginViewModel: LoginViewModel
    let profileListViewModelFactory: Factory<ProfileListViewModel>
    
    @Published var me: ProfileEntitiy?
    @Published var isLogin = false
    
    private var cancellables = Set<AnyCancellable>()
    
    public init(
        container: Container
    ) {
        self.container = container
        self.profileUseCase = container.profileUseCase()
        self.loginViewModel = container.loginViewModel()
        self.profileListViewModelFactory = container.profileListViewModel
        
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
