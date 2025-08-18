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
            Text("Profile Detail View")
        }
        .modifier(BackgroundModifier())
        .navigationBarBackButtonHidden()
        .onAppear {
            Task {
                try await model.fetchProfile()
            }
        }
    }
}
