import Factory
import Domain
import DataSource

// MARK: - Dependency Container Extensions
// Following Factory's Composition Root pattern, this is where all dependencies are wired together

// MARK: - DataSource Layer Dependencies
extension Container {
    
    // MARK: Repositories
    var jwtRepository: Factory<PJWTRepository> {
        self { 
            JWTRepository.shared
        }
        .singleton
    }
    
    var profileRepository: Factory<PProfileRepository> {
        self {
            ProfileRepository.shared
        }
        .singleton
    }
    
    var authRepository: Factory<PAuthRepository> {
        self {
            AuthRepository()
        }
        .singleton
    }
    
    var qnaRepository: Factory<PQnARepository> {
        self {
            QnARepository()
        }
        .singleton
    }
    
    var verificationRepository: Factory<PVerificationRepository> {
        self {
            VerificationRepository()
        }
        .singleton
    }
}

// MARK: - Use Case Layer Dependencies
extension Container {
    
    var profileUseCase: Factory<ProfileUseCase> {
        self {
            ProfileUseCase(
                jwtRepository: self.jwtRepository(),
                profileRepository: self.profileRepository()
            )
        }
        .singleton
    }
    
    var authUseCase: Factory<AuthUseCase> {
        self {
            AuthUseCase(
                authRepository: self.authRepository(),
                jwtRepository: self.jwtRepository()
            )
        }
        .singleton
    }
    
    var qnaUseCase: Factory<QNAUseCase> {
        self {
            QNAUseCase(
                profileRepository: self.profileRepository(),
                qnaRepository: self.qnaRepository()
            )
        }
        .singleton
    }
}

extension Container {
    public var contentViewModel: Factory<ContentViewModel> {
        self {
            .init()
        }
        .singleton
    }
}
