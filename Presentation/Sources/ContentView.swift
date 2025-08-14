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
                ProfileListView(model: model.profileListViewModelFactory())
            } else {
                LoginView(model: model.loginViewModel)
            }
        }
        .onAppear {
            model.getMe()
        }
    }
}
