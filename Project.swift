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
            name: "ThirdParty",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.tuist.ongi-swiftui.ThirdParty",
            deploymentTargets: .iOS("18.0"),
            sources: ["ThirdParty/Sources/**"],
            dependencies: [
                .external(name: "Alamofire"),
                .external(name: "Factory"),
                .external(name: "Kingfisher"),
                .external(name: "SocketIO"),
                .external(name: "SnapKit")
            ]
        ),
        .target(
            name: "DataSource",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.tuist.ongi-swiftui.DataSource",
            deploymentTargets: .iOS("18.0"),
            sources: ["DataSource/Sources/**"],
            dependencies: [.target(name: "Domain"), .target(name: "ThirdParty")]
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
            dependencies: [.target(name: "Domain"), .target(name: "DataSource")]
        ),
        .target(
            name: "ongi-swiftui",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.ongi-swiftui",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .extendingDefault(
                with: [
                    "CFBundleDisplayName": "온기",
                    "CFBundleVersion": "2",
                    "CFBundleShortVersionString": "1.0.0",
                    "CFBundleURLTypes": [
                        [
                            "CFBundleURLName": "io.tuist.ongi-swiftui",
                            "CFBundleURLSchemes": ["ongi"]
                        ]
                    ],
                    "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "NSPhotoLibraryUsageDescription": "프로필 사진을 선택하기 위해 사진 라이브러리에 접근합니다.",
                    "NSLocationWhenInUseUsageDescription": "위치 정보를 허용하시면 회원님과 가까운 거리에 있는 사용자들을 우선적으로 추천해드릴 수 있습니다. 더 가까운 곳에서 새로운 만남을 시작해보세요!",
                    "NSLocationAlwaysAndWhenInUseUsageDescription": "위치 정보를 허용하시면 회원님과 가까운 거리에 있는 사용자들을 우선적으로 추천해드릴 수 있습니다. 더 가까운 곳에서 새로운 만남을 시작해보세요!"
                ]
            ),
            sources: ["ongi-swiftui/Sources/**"],
            resources: ["ongi-swiftui/Resources/**"],
            dependencies: [
                .target(name: "Domain"),
                .target(name: "ThirdParty"),
                .target(name: "DataSource"),
                .target(name: "Presentation")
            ],
            settings: .settings(
                base: [
                    "DEVELOPMENT_TEAM": "YV58Q28W8Z"
                ],
                configurations: [
                    .debug(name: "Debug", settings: ["CODE_SIGN_ENTITLEMENTS": "ongi-swiftui/ongi-swiftui.entitlements"]),
                    .release(name: "Release", settings: ["CODE_SIGN_ENTITLEMENTS": "ongi-swiftui/ongi-swiftui.entitlements"])
                ]
            )
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
    ],
    resourceSynthesizers: [.assets()]
)
