import SwiftUI

public struct ContentView: View {
    
    public init() { }
    
    public var body: some View {
        VStack {
            Text("안녕")
                .font(.pretendard(.bold, size: 40))
            
            Text("안녕")
                .font(.custom("asd", size: 40))
        }
    }
}

#if DEBUG
#Preview {
    ContentView()
}
#endif
