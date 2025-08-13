import ProjectDescription

let project = Project(
    name: "ongi-swiftui",
    targets: [
        .target(
            name: "Domain",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.tuist.ongi-swiftui.Domain",
            deploymentTargets: .iOS("18.0"),
            sources: ["Domain/Sources/**"],
            dependencies: []
        ),
        .target(
            name: "Presentation",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.tuist.ongi-swiftui.Presentation",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UIAppFonts": [
                        "Pretendard-Thin.otf",
                        "Pretendard-ExtraLight.otf",
                        "Pretendard-Light.otf",
                        "Pretendard-Regular.otf",
                        "Pretendard-Medium.otf",
                        "Pretendard-SemiBold.otf",
                        "Pretendard-Bold.otf",
                        "Pretendard-ExtraBold.otf",
                        "Pretendard-Black.otf",
                    ]
                ]
            ),
            sources: ["Presentation/Sources/**"],
            resources: ["Presentation/Resources/**"],
            dependencies: [.target(name: "Domain")]
        ),
        .target(
            name: "ongi-swiftui",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.ongi-swiftui",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["ongi-swiftui/Sources/**"],
            resources: ["ongi-swiftui/Resources/**"],
            dependencies: [.target(name: "Domain"), .target(name: "Presentation")]
        ),
        .target(
            name: "ongi-swiftuiTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.ongi-swiftuiTests",
            infoPlist: .default,
            sources: ["ongi-swiftui/Tests/**"],
            resources: [],
            dependencies: [.target(name: "ongi-swiftui")]
        ),
    ]
)
