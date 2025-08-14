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
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    public init() {
        
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
        let fullName = credential.fullName
        let email = credential.email
        
        // TODO: Implement Apple Sign In with backend
        print("Apple Sign In Success:")
        print("User ID: \(userID)")
        print("Name: \(fullName?.formatted() ?? "N/A")")
        print("Email: \(email ?? "N/A")")
        
        // Mock success
//        isLoginSuccess = true
    }
}
