//
//  MockVerificationRepository.swift
//  Presentation
//
//  Created by 신동규 on 8/17/25.
//

import Domain

final class MockVerificationRepository: PVerificationRepository {
    
    func verify(code: String) async throws {
        try await Task.sleep(for: .seconds(1))
        throw AppError.custom("Wrong verify code")
    }
    
    func sendCompany(email: String) async throws {
        try await Task.sleep(for: .seconds(1))
        throw AppError.custom("Verification code sent to your company email")
    }
}
