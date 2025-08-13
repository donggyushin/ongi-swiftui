import SwiftUI

public struct ContentView: View {
    
    public init() { }
    
    public var body: some View {
        Text("Hello World")
            .pretendardTitle1()
    }
}

#if DEBUG
#Preview {
    ContentView()
}
#endif
