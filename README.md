# Ongi SwiftUI

A modern SwiftUI iOS application built with **Tuist** for modular architecture and **Factory** for dependency injection.

## Features

- 🏗️ **Clean Modular Architecture** - 5-layer separation with clear dependency boundaries
- 💉 **Dependency Injection** - Factory-based DI with composition root pattern
- 🎨 **Custom Typography** - Pretendard font system with SwiftUI modifiers
- 🌐 **Network Layer** - Alamofire-based networking with automatic JWT token injection
- 🧪 **Testing Support** - Comprehensive mocking system with context-based registration
- 📱 **iOS 18.0+** - Built for modern iOS with latest SwiftUI features

## Architecture

```
ongi-swiftui (App Layer)
    ↓
Presentation (UI Layer) ────┐
    ↓                       ↓
Domain (Business Logic)  DataSource (Data & Network)
                            ↓
                      ThirdParty (External Libraries)
```

**Key Principles:**
- **Clean Architecture** with unidirectional dependencies
- **Composition Root** pattern for dependency injection  
- **Protocol-first** design for testability
- **Use Case** driven business logic
- **Context-based Mocking** - Automatic mock injection for Previews and Tests

## Requirements

- **Xcode 16.4+**
- **iOS 18.0+**
- **Tuist** (for project generation)

## Quick Start

1. **Install Tuist:**
   ```bash
   curl -Ls https://install.tuist.io | bash
   ```

2. **Setup Project:**
   ```bash
   tuist install && tuist generate
   ```

3. **Open in Xcode:**
   ```bash
   open ongi-swiftui.xcworkspace
   ```

## Development Workflow

### Project Management
```bash
# After dependency changes
tuist install && tuist generate

# After Project.swift changes  
tuist generate

# Build and test
tuist build
tuist test
```

### Adding New Features

1. **Create Entity** (Domain layer)
2. **Define Repository Protocol** (Domain layer)
3. **Implement Repository** (DataSource layer)
4. **Create Use Case** (Domain layer)
5. **Register Dependencies** (DI Container)
6. **Build ViewModel** (Presentation layer)
7. **Create SwiftUI View** (Presentation layer)

### Dependency Injection

**Register dependencies in `Container+Dependencies.swift`:**
```swift
var myUseCase: Factory<MyUseCase> {
    self { MyUseCase(repository: self.myRepository()) }
        .singleton
}

var myViewModel: Factory<MyViewModel> {
    self { MyViewModel(useCase: self.myUseCase()) }
}
```

**Use in SwiftUI views:**
```swift
ContentView(model: Container.shared.contentViewModel())
```

## Project Structure

```
├── Domain/              # Business logic, entities, use cases
├── DataSource/          # Repository implementations, DTOs, networking  
├── Presentation/        # ViewModels, Views, UI components, DI Container
├── ThirdParty/          # External libraries (Alamofire, Factory)
├── ongi-swiftui/        # Main app, composition root
└── Tuist/              # Project configuration
```

## External Dependencies

- **[Alamofire](https://github.com/Alamofire/Alamofire)** - HTTP networking
- **[Factory](https://github.com/hmlongco/Factory)** - Dependency injection

## Testing

**Unit Testing:**
```swift
func testMyFeature() {
    Container.push()
    defer { Container.pop() }
    
    Container.shared.myRepository.register { MockRepository() }
    let viewModel = Container.shared.myViewModel()
    
    // Test logic...
}
```

**SwiftUI Previews:**
```swift
#Preview {
    // Mocks automatically injected via .onPreview registrations
    ContentView(model: Container.shared.contentViewModel())
}
```

## Font System

Custom **Pretendard** font system with SwiftUI modifiers:

```swift
Text("Title")
    .pretendardTitle1()

Text("Body text")
    .pretendardBody()
```

## Error Handling

Comprehensive error system with `AppError` enum:

```swift
// Network errors
throw AppError.network(.noConnection)

// Authentication errors  
throw AppError.auth(.tokenExpired)

// Custom errors
throw AppError.custom("Something went wrong", code: 1001)
```

## Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Follow the architecture guidelines
4. Add tests for new functionality
5. Update dependencies in DI container
6. Submit a pull request

## Documentation

- 📖 **[CLAUDE.md](./CLAUDE.md)** - Comprehensive development guide
- 🏗️ **[Project.swift](./Project.swift)** - Tuist project configuration
- 📦 **[Package.swift](./Tuist/Package.swift)** - External dependencies

---

**Built with ❤️ using SwiftUI, Tuist, and modern iOS development practices**
