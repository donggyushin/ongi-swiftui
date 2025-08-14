import Factory
import Foundation

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
        // Register debug/mock implementations
        // Example:
        // shared.networkManager.onArg("mock") { MockNetworkManager() }
        // shared.jwtRepository.onPreview { MockJWTRepository() }
    }
    #endif
    
    /// Setup environment-specific defaults
    private static func setupEnvironmentDefaults() {
        // Configure default scopes and behaviors
        shared.manager.defaultScope = .singleton
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
