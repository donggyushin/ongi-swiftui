import SwiftUI
import Presentation
import Factory

@main
struct OngiSwiftuiApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var model: AppModel
    
    init() {
        // Setup dependency injection container
        Container.setupApp()
        _model = .init(wrappedValue: .init())
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
