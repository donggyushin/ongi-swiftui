//
//  ProfileDetailView.swift
//  Presentation
//
//  Created by 신동규 on 8/18/25.
//

import SwiftUI
import Domain

public struct ProfileDetailView: View {
    
    @StateObject var model: ProfileDetailViewModel
    
    public init(model: ProfileDetailViewModel) {
        self._model = .init(wrappedValue: model)
    }
    
    public var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.pink.opacity(0.1),
                    Color.purple.opacity(0.05),
                    Color.white
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden()
    }
}
