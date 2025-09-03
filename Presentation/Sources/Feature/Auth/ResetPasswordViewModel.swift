//
//  ResetPasswordViewModel.swift
//  Presentation
//
//  Created by 신동규 on 9/3/25.
//

import SwiftUI
import Domain
import Combine
import Factory

final class ResetPasswordViewModel: ObservableObject {
    
    @Injected(\.passwordResetUseCase) private var passwordResetUseCase
    
    @Published var loading = false
    @Published var leftTimeInterval: TimeInterval = 180
    
    @Published var code = ""
    @Published var password = ""
    
    private var verificationCodeExpiredAt = Date()
    
    private let email: String
    
    init(email: String) {
        self.email = email
    }
    
    @MainActor
    func resetPassword() async throws {
        guard loading == false else { return }
        loading = true
        defer { loading = false }
        
        try await passwordResetUseCase.reset(code: code, newPassword: password)
    }
    
    @MainActor
    func verifyCode() async throws {
        guard loading == false else { return }
        loading = true
        defer { loading = false }
        
        let email = try await passwordResetUseCase.verifyCode(code: code)
        
        if email != self.email {
            throw AppError.authenticationError(.invalidCredentials)
        }
    }
    
    @MainActor
    func requestVerificationCode() async throws {
        guard loading == false else { return }
        loading = true
        defer { loading = false }
        try await passwordResetUseCase.sendCode(email: email)
        leftTimeInterval = 180
        verificationCodeExpiredAt = Date() + 180
    }
    
    // TODO: - 0.5초에 한 번씩 불려야 함
    @MainActor
    private func setLeftTimeInterval() {
        leftTimeInterval = max(0, verificationCodeExpiredAt.timeIntervalSince1970 - Date().timeIntervalSince1970)
    }
}
