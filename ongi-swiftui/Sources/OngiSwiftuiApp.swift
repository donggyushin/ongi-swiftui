import SwiftUI
import Presentation
import Factory

@main
struct OngiSwiftuiApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        // Setup dependency injection container
        Container.setupApp()
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(model: Container.shared.contentViewModel())
                .tint(OngiSwiftuiAsset.Assets.accentColor.swiftUIColor)
                .onOpenURL { url in
                    urlSchemeManager.implement(url)
                }
        }
    }
}
