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
        VStack(spacing: 40) {
            Spacer()
            
            VStack(spacing: 16) {
                Text("프로필 이미지 등록")
                    .pretendardTitle1()
                    .foregroundColor(.primary)
                
                Text("얼굴이 제대로 나온 사진을 사용하면\n더 좋은 매칭 결과를 얻을 수 있어요")
                    .pretendardBody()
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 24) {
                Button(action: {
                    model.showImagePicker = true
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.1))
                            .frame(width: 120, height: 120)
                        
                        if let profileImage = model.profileImage {
                            Image(uiImage: profileImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                        } else {
                            VStack(spacing: 8) {
                                Image(systemName: "camera.fill")
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                                
                                Text("사진 추가")
                                    .pretendardCaption()
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                if model.profileImage == nil {
                    Text("탭하여 프로필 이미지를 추가해주세요")
                        .pretendardCaption()
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Button(action: {
                print("move to next step")
            }) {
                Text("다음")
                    .pretendardBody()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(model.profileImage != nil ? Color.accentColor : Color.gray.opacity(0.3))
                    .cornerRadius(12)
            }
            .disabled(model.profileImage == nil)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 34)
        .navigationBarBackButtonHidden()
        .modifier(BackgroundModifier())
    }
}

#if DEBUG
private struct OnboardingProfileImageViewPreview: View {
    var body: some View {
        OnboardingProfileImageView(model: Container.shared.onboardingProfileImageViewModel())
    }
}

#Preview {
    OnboardingProfileImageViewPreview()
}
#endif
