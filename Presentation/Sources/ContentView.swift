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
                Text("로그인 상태입니다.")
                    .pretendardTitle1()
            } else {
                Text("로그아웃 상태입니다.")
                    .pretendardTitle1()
            }
        }
        .onAppear {
            model.getMe()
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


