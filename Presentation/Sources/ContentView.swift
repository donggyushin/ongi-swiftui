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
                    ProfileListView(model: model.container.profileListViewModel())
                    if model.onboarding {
                        OnboardingView(model: model.container.onboardingViewModel())
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
        ContentView(model: Container.shared.contentViewModel())
    }
}

#Preview {
    ContentViewPreview()
}
#endif
