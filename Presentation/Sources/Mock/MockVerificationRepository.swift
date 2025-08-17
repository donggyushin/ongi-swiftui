//
//  MockVerificationRepository.swift
//  Presentation
//
//  Created by 신동규 on 8/17/25.
//

import Domain

final class MockVerificationRepository: PVerificationRepository {
    func sendCompany(email: String) async throws {
        throw AppError.custom("Verification code sent to your company email")
    }
}
