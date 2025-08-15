import SwiftUI

struct DialogModifier: ViewModifier {
    let title: String?
    let message: String
    let primaryButtonText: String
    let secondaryButtonText: String?
    let primaryAction: () -> Void
    let secondaryAction: (() -> Void)?
    @Binding var isPresented: Bool
    
    func body(content: Content) -> some View {
        content
            .alert(title ?? "알림", isPresented: $isPresented) {
                Button(primaryButtonText, action: primaryAction)
                
                if let secondaryButtonText = secondaryButtonText,
                   let secondaryAction = secondaryAction {
                    Button(secondaryButtonText, action: secondaryAction)
                }
            } message: {
                Text(message)
            }
    }
}

extension View {
    func dialog(
        title: String? = nil,
        message: String,
        primaryButtonText: String = "확인",
        primaryAction: @escaping () -> Void = {},
        isPresented: Binding<Bool>
    ) -> some View {
        self.modifier(
            DialogModifier(
                title: title,
                message: message,
                primaryButtonText: primaryButtonText,
                secondaryButtonText: nil,
                primaryAction: primaryAction,
                secondaryAction: nil,
                isPresented: isPresented
            )
        )
    }
    
    func dialog(
        title: String? = nil,
        message: String,
        primaryButtonText: String = "확인",
        secondaryButtonText: String = "취소",
        primaryAction: @escaping () -> Void = {},
        secondaryAction: @escaping () -> Void = {},
        isPresented: Binding<Bool>
    ) -> some View {
        self.modifier(
            DialogModifier(
                title: title,
                message: message,
                primaryButtonText: primaryButtonText,
                secondaryButtonText: secondaryButtonText,
                primaryAction: primaryAction,
                secondaryAction: secondaryAction,
                isPresented: isPresented
            )
        )
    }
}
