import Factory
import SwiftUI
import Presentation

// MARK: - DI Usage Examples
/*
 This file contains examples of how to use the dependency injection system
 
 1. COMPOSITION ROOT PATTERN (Current Implementation)
    - Dependencies are resolved at app startup
    - Clean separation of concerns
    - Easy testing and mocking
 
 2. PROPERTY WRAPPER PATTERN (Alternative)
    - Dependencies injected via @Injected property wrapper
    - Lazy resolution
    - More flexible but requires careful setup
 */

// MARK: - Example 1: Current Composition Root Pattern
/*
 In OngiSwiftuiApp.swift:
 
 @main
 struct OngiSwiftuiApp: App {
     init() {
         Container.setupApp()
     }
     
     var body: some Scene {
         WindowGroup {
             ContentView(model: Container.shared.contentViewModel())
         }
     }
 }
 */

// MARK: - Example 2: Using ProfileUseCase
/*
 How to use ProfileUseCase in your view models:
 
 class ProfileViewModel: ObservableObject {
     private let profileUseCase: ProfileUseCase
     @Published var profile: ProfileEntitiy?
     
     init(profileUseCase: ProfileUseCase) {
         self.profileUseCase = profileUseCase
     }
     
     func loadProfile() async {
         do {
             profile = try await profileUseCase.getMe()
         } catch {
             // Handle error
         }
     }
 }
 
 // Register in Container+Dependencies.swift:
 var profileViewModel: Factory<ProfileViewModel> {
     self { 
         ProfileViewModel(profileUseCase: self.profileUseCase()) 
     }
 }
 */

// MARK: - Example 3: Alternative Property Wrapper Pattern
/*
 If you prefer property wrapper injection:
 
 class ContentViewModelWithInjection: ObservableObject {
     @Injected(\.jwtRepository) private var jwtRepository
     @Injected(\.profileUseCase) private var profileUseCase
     
     func loadUserProfile() async {
         let profile = try await profileUseCase.getMe()
     }
 }
 */

// MARK: - Example 3: Testing Patterns
/*
 In your test files:
 
 class ViewModelTests: XCTestCase {
     override func setUp() {
         Container.push()  // Save current state
         Container.setupMocks()  // Register mocks
     }
     
     override func tearDown() {
         Container.pop()  // Restore previous state
     }
     
     func testLogin() {
         // Register specific mock for this test
         Container.shared.jwtRepository.register { 
             MockJWTRepository(shouldSucceed: true)
         }
         
         let viewModel = Container.shared.contentViewModel()
         // Test your logic...
     }
 }
 */

// MARK: - Example 4: SwiftUI Previews
/*
 In your SwiftUI preview files:
 
 struct ContentView_Previews: PreviewProvider {
     static var previews: some View {
         // Register preview-specific mocks
         let _ = Container.shared.jwtRepository.register {
             MockJWTRepository()
         }
         
         ContentView(model: Container.shared.contentViewModel())
     }
 }
 
 // Or use Factory's context system:
 // Factory automatically applies .onPreview registrations in previews
 */