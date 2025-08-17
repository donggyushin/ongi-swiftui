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
    
    @Published var expiredDate: Date?
    
    var verificationLeftTime: Int {
        guard let expiredDate else { return 300 }
        return Int(expiredDate.timeIntervalSince1970 - Date().timeIntervalSince1970)
    }
    
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
        expiredDate = Date() + 300
    }
    
    @MainActor
    func verifyEmail() async throws {
        loading = true
        defer { loading = false }
        
        try await authUseCase.verifyEmailVerificationCode(code: verificationCode)
    }
    
    @MainActor
    func reset() {
        withAnimation {
            companyEmail = ""
            verificationCode = ""
            showCodeInput = false
            expiredDate = nil
        }
    }
}
