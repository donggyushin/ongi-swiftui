import SwiftUI
import Presentation
import Factory

@main
struct OngiSwiftuiApp: App {
    
    init() {
        // Setup dependency injection container
        Container.setupApp()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(model: Container.shared.contentViewModel())
                .tint(OngiSwiftuiAsset.Assets.accentColor.swiftUIColor)
        }
    }
}
