//
//  AuthUseCase.swift
//  Domain
//
//  Created by 신동규 on 8/14/25.
//

public final class AuthUseCase {
    let authRepository: PAuthRepository
    let jwtRepository: PJWTRepository
    
    public init(
        authRepository: PAuthRepository,
        jwtRepository: PJWTRepository
    ) {
        self.authRepository = authRepository
        self.jwtRepository = jwtRepository
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
