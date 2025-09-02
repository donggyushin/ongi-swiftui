//
//  PasswordResetUseCase.swift
//  Domain
//
//  Created by 신동규 on 9/2/25.
//

import Foundation

public final class PasswordResetUseCase {
    let authRepository: PAuthRepository
    
    public init(authRepository: PAuthRepository) {
        self.authRepository = authRepository
    }
    
    public func sendCode(email: String) async throws {
        try await authRepository.sendCode(email: email)
    }
    public func verifyCode(code: String) async throws -> String {
        try await authRepository.verifyCode(code: code)
    }
    public func reset(code: String, newPassword: String) async throws {
        try await authRepository.reset(code: code, newPassword: newPassword)
    }
}
