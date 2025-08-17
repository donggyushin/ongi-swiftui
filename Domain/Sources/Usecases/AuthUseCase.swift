//
//  AuthUseCase.swift
//  Domain
//
//  Created by 신동규 on 8/14/25.
//

public final class AuthUseCase {
    let authRepository: PAuthRepository
    let jwtRepository: PJWTRepository
    let verificationRepository: PVerificationRepository
    
    public init(
        authRepository: PAuthRepository,
        jwtRepository: PJWTRepository,
        verificationRepository: PVerificationRepository
    ) {
        self.authRepository = authRepository
        self.jwtRepository = jwtRepository
        self.verificationRepository = verificationRepository
    }
    
    public func sendVerificationCode(companyEmail: String) async throws {
        try await verificationRepository.sendCompany(email: companyEmail)
    }
    
    public func loginOrSignup(id: String, type: String) async throws {
        guard type == "apple" else { throw AppError.dataError(.corruptedData) }
        let tokens = try await authRepository.loginOrSignup(id: id, type: type)
        jwtRepository.saveTokens(tokens)
    }
    
    public func logout() {
        jwtRepository.removeToken()
    }
}
