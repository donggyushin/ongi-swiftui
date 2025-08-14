import SwiftUI
import Factory

public struct ContentView: View {
    
    @StateObject var model: ContentViewModel

    public init(model: ContentViewModel) {
        _model = .init(wrappedValue: model)
    }

    public var body: some View {
        VStack {
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
    }
}
