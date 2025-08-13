import ProjectDescription

let project = Project(
    name: "ongi-swiftui",
    targets: [
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
            dependencies: []
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
