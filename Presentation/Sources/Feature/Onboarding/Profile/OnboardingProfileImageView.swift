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
    
    @State var errorMessage: String?
    
    var complete: (() -> ())?
    func onComplete(_ action: (() -> ())?) -> Self {
        var copy = self
        copy.complete = action
        return copy
    }
    
    var body: some View {
        VStack(spacing: 20) {
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
            
            if model.loadingInitialImage == false {
                VStack(spacing: 24) {
                    Button {
                        model.selectImage()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.1))
                                .frame(width: 120, height: 120)
                            
                            if let profileImage = model.profileImage {
                                Image(uiImage: profileImage)
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 120, height: 120)
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
            }
            
            Spacer()
            
            if let errorMessage {
                Text(errorMessage)
                    .pretendardCaption()
                    .foregroundStyle(.red)
            }
            
            Button {
                Task {
                    do {
                        withAnimation {
                            errorMessage = nil
                        }
                        try await model.uploadPhoto()
                        complete?()
                    } catch AppError.custom(let message, code: _) {
                        withAnimation {
                            errorMessage = message
                        }
                    }
                    
                }
            } label: {
                AppButton(text: "다음", disabled: model.profileImage == nil)
            }
            .disabled(model.profileImage == nil)
            
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 34)
        .modifier(BackgroundModifier())
        .sheet(isPresented: $model.showImagePicker) {
            ImagePicker()
                .onComplete { uiImage in
                    model.profileImage = uiImage
                }
        }
        .onAppear {
            Task {
                do {
                    try await model.updateProfileImage()
                } catch AppError.custom(let message, code: _) {
                    withAnimation {
                        errorMessage = message
                    }
                }
            }
        }
        .loading(model.loading)
    }
}

#if DEBUG
private struct OnboardingProfileImageViewPreview: View {
    var body: some View {
        OnboardingProfileImageView(model: .init())
    }
}

#Preview {
    OnboardingProfileImageViewPreview()
}
#endif
