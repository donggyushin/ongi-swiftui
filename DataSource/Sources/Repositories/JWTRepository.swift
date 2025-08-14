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
        // TODO: Implement remote refresh token API call
        // This will need a remote data source for API communication
        
        guard let refreshToken = getTokens()?.refreshToken else {
            throw NSError(domain: "JWTRepository", code: 0, userInfo: [NSLocalizedDescriptionKey: "인증에 실패했습니다"])
        }
        
        let authTokens = try await remoteDataSource.refreshToken(refreshToken: refreshToken)
        saveTokens(authTokens)
    }
}
