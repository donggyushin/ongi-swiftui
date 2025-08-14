import Factory
import Domain
import DataSource
import Presentation

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
}

// MARK: - Use Case Layer Dependencies
extension Container {
    
    // Add use cases here as they are created
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
            ContentViewModel(jwtRepository: self.jwtRepository()) 
        }
    }
}
