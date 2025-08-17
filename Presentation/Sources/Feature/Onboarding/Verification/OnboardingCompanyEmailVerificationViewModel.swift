//
//  OnboardingCompanyEmailVerificationViewModel.swift
//  Presentation
//
//  Created by 신동규 on 8/17/25.
//

import Domain
import Factory
import SwiftUI
import Combine

final class OnboardingCompanyEmailVerificationViewModel: ObservableObject {
    
    @Published var loading = false
    @Published var companyEmail = ""
    @Published var verificationCode = "" // 6 digits
    
    @Published var showCodeInput = false 
    
    @Published var verificationLeftTime = 300
    
    let authUseCase = Container.shared.authUseCase()
    
    init() { }
    
    @MainActor
    func sendVerificationCodeToEmail() async throws {
        loading = true
        defer { loading = false }
        
        try await authUseCase.sendVerificationCode(companyEmail: companyEmail)
        withAnimation {
            showCodeInput = true
        }
        // start count verificationLeftTime
    }
    
    @MainActor
    func verifyEmail() async throws {
        loading = true
        defer { loading = false }
        
        try await authUseCase.verifyEmailVerificationCode(code: verificationCode)
    }
}
