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
            .background(
                LinearGradient(
                    colors: [
                        Color(.systemBackground),
                        Color(.systemGray6)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
    }
}
