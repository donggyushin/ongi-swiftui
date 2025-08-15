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
                ZStack {
                    ProfileListView(model: .init())
                    if model.onboarding {
                        OnboardingView(model: .init())
                    }
                }
            } else {
                LoginView(model: model.loginViewModel)
            }
        }
        .onAppear {
            model.getMe()
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
