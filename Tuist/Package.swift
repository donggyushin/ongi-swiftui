// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        productTypes: [
            "FirebaseAnalytics": .staticFramework,
            "FirebaseAuth": .staticFramework,
            "FirebaseFirestore": .staticFramework,
            "FirebaseCrashlytics": .staticFramework,
            "FirebaseCore": .staticFramework,
            "GoogleUtilities": .staticFramework,
        ]
    )
#endif

let package = Package(
    name: "ongi-swiftui",
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.8.0"),
        .package(url: "https://github.com/hmlongco/Factory", from: "2.3.0"),
        .package(url: "https://github.com/onevcat/Kingfisher", from: "7.10.0"),
        .package(url: "https://github.com/socketio/socket.io-client-swift", from: "16.1.0"),
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.6.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "10.23.0")
    ]
)
