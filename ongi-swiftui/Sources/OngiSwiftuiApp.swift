import SwiftUI
import Presentation
import Factory

@main
struct OngiSwiftuiApp: App {
    
    @Injected(\.contentViewModel) private var contentViewModel
    
    init() {
        // Setup dependency injection container
        Container.setupApp()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(model: contentViewModel)
                .tint(OngiSwiftuiAsset.Assets.accentColor.swiftUIColor)
                .onOpenURL { url in
                    urlSchemeManager.implement(url)
                }
        }
    }
}
