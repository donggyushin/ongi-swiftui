# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a SwiftUI iOS application built with **Tuist** for project generation and clean modular architecture. The app targets iOS 18.0+ and uses a dependency injection system based on Factory.

## Essential Commands

### Project Generation and Building
```bash
# Install dependencies and generate Xcode project (required after dependency changes)
tuist install && tuist generate

# Generate project only (when Project.swift changes)
tuist generate  

# Build via Tuist
tuist build

# Run tests via Tuist  
tuist test
```

### Development Workflow
- Always run `tuist generate` after modifying `Project.swift`, `Tuist/Package.swift`, or project structure
- Use `tuist install` before `tuist generate` when external dependencies change
- Open `ongi-swiftui.xcworkspace` (not .xcodeproj) in Xcode after generation

## Architecture Overview

### Modular Clean Architecture
The project uses a **5-layer modular architecture** with clear dependency boundaries:

```
ongi-swiftui (App) 
    ↓
Presentation (UI Layer)
    ↓  
Domain (Business Logic)
    ↓
DataSource (Data Layer) 
    ↓
ThirdParty (External Libraries)
```

**Dependency Rules:**
- **Higher layers depend on lower layers, never the reverse**
- **ThirdParty**: Contains external libraries (Alamofire, Factory) - no dependencies
- **Domain**: Business entities, use cases, repository protocols - depends on nothing
- **DataSource**: Repository implementations, DTOs, network layer - depends on Domain + ThirdParty  
- **Presentation**: ViewModels, Views - depends on Domain + ThirdParty
- **ongi-swiftui**: Main app, composition root - depends on all modules

### Key Architecture Points

**Dependency Injection System:**
- Uses **Factory** framework with **Composition Root pattern**
- DI Container located in `ongi-swiftui/Sources/DI/`
- `Container+Dependencies.swift` - All dependency registrations
- `Container+Setup.swift` - Configuration, mocking, testing support
- Dependencies resolved at app startup in `OngiSwiftuiApp.init()`

**External Libraries Management:**
- **Factory** and **Alamofire** are registered in **ThirdParty module only**
- Main app accesses these through ThirdParty dependency, not directly
- Never add external dependencies directly to main app module

**Data Flow Pattern:**
- **Entities** (Domain) → **DTOs** (DataSource) → **ResponseDTOs** with **Mappers**  
- **Use Cases** orchestrate business logic between repositories
- **ViewModels** use use cases, never repositories directly
- **NetworkManager** (DataSource) handles all API communication with JWT interceptor

### Testing and Mocking

**Mock System:**
- Context-based mocking via Factory: `.onPreview`, `.onTest`, `.onDebug`
- Mock implementations in `Container+Setup.swift` 
- `Container.setupMocks()` for test setup
- `Container.push()/pop()` for test isolation

**SwiftUI Previews:**
- Mocks automatically injected via `.onPreview` registrations
- Use `Container.shared.contentViewModel()` in previews
- Custom mocks: manually register before creating views

## Module-Specific Notes

### Domain Module
- Contains business entities, use cases, repository protocols
- **AppError** enum provides comprehensive error handling
- **MBTI types**, **AuthTokens**, **Profile entities**
- Never depends on other modules

### DataSource Module  
- **NetworkManager** with Alamofire + JWT auto-injection
- **Repository implementations** (JWTRepository, ProfileRepository)
- **DTOs and Mappers** for API response transformation
- Singleton pattern for shared instances

### Presentation Module
- **Custom Pretendard font system** with modifiers
- **ViewModels** use constructor injection pattern
- SwiftUI views receive ViewModels via DI Container

### Font System
- **Pretendard font family** loaded via Info.plist configuration
- Custom font modifiers in `FontModifier.swift`
- Usage: `.pretendardTitle1()`, `.pretendardBody()`, etc.

## Development Guidelines

### Adding New Dependencies
1. Add to `Tuist/Package.swift`
2. Register in appropriate module's `Project.swift` dependencies
3. Run `tuist install && tuist generate`
4. **External libraries go in ThirdParty module only**

### Adding New Features
1. Create **Entity** in Domain if needed
2. Add **Repository protocol** in Domain  
3. Implement **Repository** in DataSource
4. Create **Use Case** in Domain
5. Register all in **DI Container** (`Container+Dependencies.swift`)
6. Create **ViewModel** in Presentation with constructor injection
7. Create **View** in Presentation

### Dependency Injection Patterns
```swift
// Preferred: Constructor injection
class MyViewModel: ObservableObject {
    private let useCase: MyUseCase
    
    init(useCase: MyUseCase) {
        self.useCase = useCase
    }
}

// Register in Container+Dependencies.swift:
var myViewModel: Factory<MyViewModel> {
    self { MyViewModel(useCase: self.myUseCase()) }
}

// Alternative: Property wrapper (less preferred)  
@Injected(\.myUseCase) private var useCase
```

### Error Handling
Use **AppError** enum from Domain for consistent error handling:
```swift
throw AppError.network(.noConnection)
throw AppError.auth(.tokenExpired) 
throw AppError.custom("Custom message", code: 1001)
```