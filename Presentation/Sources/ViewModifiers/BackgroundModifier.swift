//
//  BackgroundModifier.swift
//  Presentation
//
//  Created by 신동규 on 8/15/25.
//

import SwiftUI

struct BackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.pink.opacity(0.1),
                        Color.purple.opacity(0.05),
                        Color(uiColor: UIColor.systemBackground),
                        Color.pink.opacity(0.1)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
    }
}
