import Foundation
import Domain

public final class JWTRepository: PJWTRepository {
    public static let shared = JWTRepository()
    
    private let localDataSource = JWTLocalDataSource()
    private let remoteDataSource = JWTRemoteDataSource()
    
    private init() {
        
    }
    
    public func saveTokens(_ tokens: AuthTokensEntity) {
        localDataSource.saveTokens(tokens)
    }
    
    public func getTokens() -> AuthTokensEntity? {
        return localDataSource.getTokens()
    }
    
    public func refreshToken() async throws {
        guard let refreshToken = getTokens()?.refreshToken else {
            throw AppError.authenticationError(.tokenNotFound)
        }
        
        let authTokens = try await remoteDataSource.refreshToken(refreshToken: refreshToken)
        saveTokens(authTokens)
    }
    
    public func removeToken() {
        localDataSource.clearTokens()
    }
}
