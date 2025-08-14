//
//  ContentViewModel.swift
//  Presentation
//
//  Created by 신동규 on 8/14/25.
//

import Combine
import Domain
import Foundation

public final class ContentViewModel: ObservableObject {
    
    let profileUseCase: ProfileUseCase
    
    @Published var me: ProfileEntitiy?
    @Published var isLogin = false
    
    private var cancellables = Set<AnyCancellable>()
    
    
    public init(profileUseCase: ProfileUseCase) {
        self.profileUseCase = profileUseCase
        
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
    }
}
