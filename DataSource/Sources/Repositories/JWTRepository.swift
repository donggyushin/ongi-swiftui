import Foundation
import Domain

public final class JWTRepository: PJWTRepository {
    
    public static let shared = JWTRepository()
    
    private let localDataSource = JWTLocalDataSource()
    
    private init() {
        
    }
    
    public func saveTokens(_ tokens: AuthTokensEntity) {
        localDataSource.saveTokens(tokens)
    }
    
    public func getTokens() -> AuthTokensEntity? {
        return localDataSource.getTokens()
    }
    
    public func refreshToken() async throws {
        // TODO: Implement remote refresh token API call
        // This will need a remote data source for API communication
        throw NSError(domain: "JWTRepository", code: 0, userInfo: [NSLocalizedDescriptionKey: "refreshToken not implemented yet"])
    }
}
