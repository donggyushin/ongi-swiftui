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
import Factory

public final class LoginViewModel: ObservableObject {
    
    @Injected(\.authUseCase) private var authUseCase
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    
    var loginSuccessSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Initialization
    public init() { }
    
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
            loginSuccessSubject.send()
        }
    }
}
