import Factory
import Foundation
import DataSource

// MARK: - Container Setup and Configuration
extension Container {
    
    /// Setup dependencies for the application
    /// Call this once during app initialization
    public static func setupApp() {
        #if DEBUG
        setupDebugEnvironment()
        #endif
        
        setupEnvironmentDefaults()
    }
    
    #if DEBUG
    /// Setup debug-specific configurations
    private static func setupDebugEnvironment() {
        // Register mock implementations for Previews
        shared.jwtRepository.onPreview { MockJWTRepository() }
        shared.profileRepository.onPreview { MockProfileRepository() }
        shared.authRepository.onPreview { MockAuthRepository() }
        shared.qnaRepository.onPreview { MockQnARepository() }
        shared.verificationRepository.onPreview { MockVerificationRepository() }
        shared.connectionRepository.onPreview { MockConnectionRepository() }
        shared.chatRepository.onPreview { MockChatRepository() }
        shared.socketRemoteDataSource.onPreview { MockSocketRemoteDataSource() }
        shared.reportRepository.onPreview { MockReportRepository() }
        shared.notificationsRepository.onPreview { MockNotificationsRepository() }
    }
    #endif
    
    /// Setup environment-specific defaults
    private static func setupEnvironmentDefaults() {
        // Configure default scopes and behaviors
        shared.manager.defaultScope = .singleton
        
        // Enable network logging
        #if DEBUG
        NetworkManager.shared.isLoggingEnabled = true
        #else
        NetworkManager.shared.isLoggingEnabled = false
        #endif
    }
}

// MARK: - Testing Support
extension Container {
    
    /// Setup mock dependencies for testing
    static func setupMocks() {
        // Register common mock implementations for testing
        // This can be called from test setup methods
        
        // Example:
        // shared.jwtRepository.register { MockJWTRepository() }
        // shared.networkManager.register { MockNetworkManager() }
        
        shared.jwtRepository.register { MockJWTRepository() }
        shared.profileRepository.register { MockProfileRepository() }
        shared.socketRemoteDataSource.register { MockSocketRemoteDataSource() }
    }
    
    /// Reset all dependencies - useful for testing
    static func reset() {
        shared.manager.reset()
    }
    
    /// Push current container state (for testing isolation)
    static func push() {
        shared.manager.push()
    }
    
    /// Pop container state (restore previous state)
    static func pop() {
        shared.manager.pop()
    }
}
