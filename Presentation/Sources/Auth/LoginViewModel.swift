//
//  LoginViewModel.swift
//  Presentation
//
//  Created by 신동규 on 8/14/25.
//

import SwiftUI
import AuthenticationServices
import Domain
import Combine

public final class LoginViewModel: ObservableObject {
    
    let authUseCase: AuthUseCase
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    public init(
        authUseCase: AuthUseCase
    ) {
        self.authUseCase = authUseCase
    }
    
    /// Apple Sign In handling
    public func handleAppleSignIn(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                handleAppleIDCredential(appleIDCredential)
            }
            
        case .failure(let error):
            print("Apple Sign In Error: \(error)")
        }
    }
    
    // MARK: - Private Methods
    
    private func handleAppleIDCredential(_ credential: ASAuthorizationAppleIDCredential) {
        let userID = credential.user
        
        Task { @MainActor in
            try await authUseCase.loginOrSignup(id: userID, type: "apple")
            // ContentViewModel에서 프로필을 한 번 업데이트 해야함
        }
    }
}
