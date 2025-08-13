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
                        "Fonts/Pretendard/Pretendard-Thin.otf",
                        "Fonts/Pretendard/Pretendard-ExtraLight.otf",
                        "Fonts/Pretendard/Pretendard-Light.otf",
                        "Fonts/Pretendard/Pretendard-Regular.otf",
                        "Fonts/Pretendard/Pretendard-Medium.otf",
                        "Fonts/Pretendard/Pretendard-SemiBold.otf",
                        "Fonts/Pretendard/Pretendard-Bold.otf",
                        "Fonts/Pretendard/Pretendard-ExtraBold.otf",
                        "Fonts/Pretendard/Pretendard-Black.otf",
                    ]
                ]
            ),
            sources: ["Presentation/Sources/**"],
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
