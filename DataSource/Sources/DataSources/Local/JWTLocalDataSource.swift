import Foundation
import Domain

public final class JWTLocalDataSource {
    
    private let userDefaults: UserDefaults
    
    private enum Keys {
        static let accessToken = "jwt_access_token"
        static let refreshToken = "jwt_refresh_token"
    }
    
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    public func saveTokens(_ tokens: AuthTokensEntity) {
        userDefaults.set(tokens.accessToken, forKey: Keys.accessToken)
        userDefaults.set(tokens.refreshToken, forKey: Keys.refreshToken)
    }
    
    public func getTokens() -> AuthTokensEntity? {
        guard let accessToken = userDefaults.string(forKey: Keys.accessToken),
              let refreshToken = userDefaults.string(forKey: Keys.refreshToken) else {
            return nil
        }
        
        return AuthTokensEntity(
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
    
    public func clearTokens() {
        userDefaults.removeObject(forKey: Keys.accessToken)
        userDefaults.removeObject(forKey: Keys.refreshToken)
    }
}
