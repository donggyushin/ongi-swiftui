import SwiftUI

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
