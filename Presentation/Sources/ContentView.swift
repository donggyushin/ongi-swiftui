import SwiftUI
import Factory

public struct ContentView: View {
    
    @StateObject var model: ContentViewModel
    @State var splash = true

    public init(model: ContentViewModel) {
        _model = .init(wrappedValue: model)
    }

    public var body: some View {
        Group {
            if model.isLogin {
                ProfileListView(model: .init())
            } else {
                LoginView(model: model.loginViewModel)
            }
        }
        .modifier(BackgroundModifier())
        .onAppear {
            model.getMe()
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
