//
//  OnboardingProfileImageView.swift
//  Presentation
//
//  Created by 신동규 on 8/15/25.
//

import SwiftUI
import Factory
import Domain

struct OnboardingProfileImageView: View {
    
    @StateObject var model: OnboardingProfileImageViewModel
    
    var body: some View {
        VStack {
            Text("프로필 이미지 등록")
        }
        .navigationBarBackButtonHidden()
    }
}
