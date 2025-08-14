import SwiftUI
import Factory

public struct ContentView: View {
    
    @StateObject var model: ContentViewModel

    public init(model: ContentViewModel) {
        _model = .init(wrappedValue: model)
    }

    public var body: some View {
        VStack {
            Text("안녕")
                .pretendardTitle1()

            Text("안녕")
                .font(.custom("asd", size: 40))
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


