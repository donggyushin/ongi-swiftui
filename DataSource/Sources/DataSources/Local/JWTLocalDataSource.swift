import Foundation
import Domain

final class JWTLocalDataSource {
    
    private let userDefaults: UserDefaults
    
    private enum Keys {
        static let accessToken = "jwt_access_token"
        static let refreshToken = "jwt_refresh_token"
    }
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func saveTokens(_ tokens: AuthTokensEntity) {
        userDefaults.set(tokens.accessToken, forKey: Keys.accessToken)
        userDefaults.set(tokens.refreshToken, forKey: Keys.refreshToken)
    }
    
    func getTokens() -> AuthTokensEntity? {
        guard let accessToken = userDefaults.string(forKey: Keys.accessToken),
              let refreshToken = userDefaults.string(forKey: Keys.refreshToken) else {
            return nil
        }
        
        return AuthTokensEntity(
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
    
    func clearTokens() {
        userDefaults.removeObject(forKey: Keys.accessToken)
        userDefaults.removeObject(forKey: Keys.refreshToken)
    }
}
