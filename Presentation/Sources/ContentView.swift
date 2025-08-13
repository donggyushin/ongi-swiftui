import SwiftUI

public struct ContentView: View {
    
    public init() { }
    
    public var body: some View {
        ScrollView {
            VStack {
                Text("안녕")
                    .font(.pretendard(.bold, size: 40))
                
                Text("안녕")
                    .font(.custom("asd", size: 40))
                
                Text("Available Font Families:")
                    .font(.caption)
                    .padding(.top)
                
                ForEach(UIFont.familyNames.sorted(), id: \.self) { familyName in
                    VStack(alignment: .leading) {
                        Text("\(familyName)")
                            .font(.headline)
                        ForEach(UIFont.fontNames(forFamilyName: familyName), id: \.self) { fontName in
                            Text("  \(fontName)")
                                .font(.caption)
                        }
                    }
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    ContentView()
}
#endif
