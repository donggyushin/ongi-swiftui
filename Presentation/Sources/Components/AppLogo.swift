//
//  AppLogo.swift
//  Presentation
//
//  Created by 신동규 on 8/15/25.
//

import SwiftUI

public struct AppLogo: View {
    
    public init() { }
    
    public var body: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(
                LinearGradient(
                    colors: [.accentColor, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                Text("온")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            )
    }
}
