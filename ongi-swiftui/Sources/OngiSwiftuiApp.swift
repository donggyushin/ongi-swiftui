import SwiftUI
import Presentation

@main
struct OngiSwiftuiApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(model: ContentViewModel())
        }
    }
}
