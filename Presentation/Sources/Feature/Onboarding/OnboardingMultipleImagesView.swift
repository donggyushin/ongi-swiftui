//
//  OnboardingMultipleImagesView.swift
//  Presentation
//
//  Created by 신동규 on 8/15/25.
//

import SwiftUI
import Domain
import Factory

struct OnboardingMultipleImagesView: View {
    
    @StateObject var model: OnboardingMultipleImagesViewModel
    
    var body: some View {
        Text("")
    }
}

#if DEBUG
#Preview {
    OnboardingMultipleImagesView(model: .init())
        .preferredColorScheme(.dark)
}
#endif
