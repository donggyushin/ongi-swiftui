import Factory
import Domain

// MARK: - Dependency Container Extensions
// Following Factory's Composition Root pattern, this is where all dependencies are wired together

// MARK: - DataSource Layer Dependencies
extension Container {
    
    // MARK: Repositories
    var jwtRepository: Factory<PJWTRepository> {
        self {
            MockJWTRepository()
        }
        .singleton
    }
    
    var profileRepository: Factory<PProfileRepository> {
        self {
            MockProfileRepository()
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
    
    // Add other use cases here as they are created
    // Example:
    // var authUseCase: Factory<AuthUseCaseProtocol> {
    //     self { AuthUseCase(repository: jwtRepository()) }
    // }
}

// MARK: - Presentation Layer Dependencies
extension Container {
    
    // MARK: View Models
    var contentViewModel: Factory<ContentViewModel> {
        self {
            ContentViewModel(profileUseCase: self.profileUseCase())
        }
    }
}
