//
//  OnboardingPhysicalGenderInfoView.swift
//  Presentation
//
//  Created by 신동규 on 8/16/25.
//

import SwiftUI
import Factory
import Domain

struct OnboardingPhysicalGenderInfoView: View {
    
    @StateObject var model: OnboardingPhysicalGenderInfoViewModel
    
    var body: some View {
        Text("OnboardingPhysicalInfoView")
    }
}

#Preview {
    OnboardingPhysicalGenderInfoView(model: .init())
}
