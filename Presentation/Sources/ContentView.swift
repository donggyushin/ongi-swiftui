import SwiftUI
import Factory

public struct ContentView: View {
    
    @StateObject var model: ContentViewModel
    @State var splash = true
    @State private var navigationPath: [Navigation] = []
    @Namespace private var heroNamespace
    
    public init(model: ContentViewModel) {
        _model = .init(wrappedValue: model)
    }
    
    public var body: some View {
        Group {
            if model.isLogin {
                NavigationStack(path: $navigationPath) {
                    ProfileListView(
                        model: .init(),
                        heroNamespace: heroNamespace
                    )
                    .navigationDestination(for: Navigation.self) { navigation in
                        switch navigation {
                        case .profileDetail(let id):
                            ProfileDetailView(
                                model: .init(profileId: id ),
                                heroNamespace: heroNamespace
                            )
                            .navigationBarBackButtonHidden()
                            .navigationTransition(
                                .zoom(
                                    sourceID: id,
                                    in: heroNamespace
                                )
                            )
                        case .zoomableImage(let url):
                            ZoomableImage(url: url)
                                .ignoresSafeArea()
                                .navigationBarBackButtonHidden()
                                .navigationTransition(
                                    .zoom(
                                        sourceID: url,
                                        in: heroNamespace
                                    )
                                )
                        case .profileDetailStack(let id):
                            ProfileDetailView(
                                model: .init(profileId: id),
                                heroNamespace: heroNamespace
                            )
                        case .profileListLikeMe:
                            ProfileListLikeMeView(model: .init())
                        case .setting:
                            SettingView(model: .init())
                        case .chatList:
                            ChatListView(model: .init())
                        case .chat(let chatId):
                            ChatView(model: .init(chatId: chatId))
                        }
                    }
                }
            } else {
                LoginView(model: model.loginViewModel)
            }
        }
        .modifier(BackgroundModifier())
        .onAppear {
            Task {
                try await model.getMe()
            }
            if navigationManager == nil {
                navigationManager = .init(navigationPath: $navigationPath)
            }
        }
        .overlay {
            if model.isLogin && model.onboarding {
                OnboardingView(
                    model: .init(),
                    isPresent: $model.onboarding
                )
            }
        }
        .overlay {
            if splash {
                SplashView()
                    .onComplete {
                        withAnimation {
                            splash = false
                        }
                    }
            }
        }
        .dialog(
            title: "인증",
            message: "인증에 실패하여 로그아웃 됩니다",
            primaryButtonText: "로그아웃",
            primaryAction: {
                model.handleLogout()
            },
            isPresented: $model.authenticationFailDialog
        )
    }
}

#if DEBUG
private struct ContentViewPreview: View {
    var body: some View {
        ContentView(model: .init())
    }
}

#Preview {
    ContentViewPreview()
}
#endif
