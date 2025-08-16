//
//  OnboardingView.swift
//  Presentation
//
//  Created by 신동규 on 8/15/25.
//

import SwiftUI
import Factory
import Domain

public struct OnboardingView: View {
    
    @StateObject var model: OnboardingViewModel
    
    @State var animation1 = false
    
    public init(model: OnboardingViewModel) {
        self._model = .init(wrappedValue: model)
    }
    
    public var body: some View {
        
        NavigationStack(path: $model.path) {
            VStack(spacing: 0) {
                
                Spacer()
                // Header Section
                headerSection
                
                Spacer()
                
                // Content Section
                contentSection
                    .padding(.horizontal, 24)
                
                Spacer()
                
                if animation1 {
                    // Action Button
                    actionButton
                        .padding(.horizontal, 24)
                        .padding(.bottom, 30)
                }
            }
            .navigationDestination(for: OnboardingNavigationPath.self) { path in
                switch path {
                case .nickname:
                    OnboardingNicknameView(model: .init())
                        .onNextAction {
                            model.nextStep()
                        }
                        .navigationBarBackButtonHidden()
                case .profileImage:
                    OnboardingProfileImageView(model: .init())
                        .onComplete {
                            model.nextStep()
                        }
                        .navigationBarBackButtonHidden()
                case .images:
                    OnboardingMultipleImagesView(model: .init())
                        .onNextAction {
                            model.nextStep()
                        }
                        .navigationBarBackButtonHidden()
                case .physicalAndGender:
                    OnboardingPhysicalGenderInfoView(model: .init())
                        .onComplete {
                            model.nextStep()
                        }
                        .navigationBarBackButtonHidden()
                case .profileSectionCompletion:
                    OnboardingProfileSectionCompletionView()
                        .onNextAction {
                            // TODO: 자기소개 스텝으로 이동
                            print("자기소개 스텝으로 이동")
                        }
                        .navigationBarBackButtonHidden()
                }
            }
        }
        .modifier(BackgroundModifier())
        .onAppear {
            Task {
                try await model.updateProfile()
                try await Task.sleep(for: .seconds(1))
                withAnimation {
                    animation1 = true
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 24) {
            // App Icon
            AppLogo()
                .frame(width: 80, height: 80)
            
            VStack(spacing: 12) {
                Text("환영합니다!")
                    .pretendardTitle1()
                    .foregroundColor(.primary)
                
                Text("온기에서 따뜻한 소통을 시작해보세요")
                    .pretendardBody()
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    private var contentSection: some View {
        VStack(spacing: 32) {
            // Why Profile Section
            VStack(spacing: 16) {
                Text("프로필을 완성해야 하는 이유")
                    .pretendardHeadline()
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(spacing: 16) {
                    reasonItem(
                        icon: "person.circle.fill",
                        title: "신뢰할 수 있는 소통",
                        description: "프로필이 완성된 사용자들과 더 안전하고 의미있는 대화를 나눠보세요"
                    )
                    
                    reasonItem(
                        icon: "heart.fill",
                        title: "맞춤형 매칭",
                        description: "당신의 관심사와 성향에 맞는 사람들을 찾아 추천해드려요"
                    )
                    
                    reasonItem(
                        icon: "sparkles",
                        title: "더 나은 첫인상",
                        description: "완성된 프로필로 상대방에게 좋은 첫인상을 남겨보세요"
                    )
                }
            }
            
            // Steps Preview
            VStack(spacing: 16) {
                Text("3단계로 완성해요")
                    .pretendardHeadline()
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 20) {
                    stepItem(number: "1", title: "프로필", subtitle: "나를 표현하기")
                    stepItem(number: "2", title: "자기 소개", subtitle: "매력 어필하기")
                    stepItem(number: "3", title: "이메일 인증", subtitle: "안전한 계정")
                }
            }
        }
    }
    
    private func reasonItem(icon: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .pretendardCallout(.semiBold)
                    .foregroundColor(.primary)
                
                Text(description)
                    .pretendardCaption1()
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        .padding(.leading, 4)
    }
    
    private func stepItem(number: String, title: String, subtitle: String) -> some View {
        VStack(spacing: 8) {
            Circle()
                .fill(.blue.opacity(0.1))
                .frame(width: 40, height: 40)
                .overlay(
                    Text(number)
                        .pretendardCallout(.semiBold)
                        .foregroundColor(.blue)
                )
            
            VStack(spacing: 2) {
                Text(title)
                    .pretendardCaption1(.medium)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text(subtitle)
                    .pretendardCaption2()
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private var actionButton: some View {
        Button {
            model.nextStep()
        } label: {
            AppButton(text: "시작하기", disabled: false)
        }
    }
}

#if DEBUG
private struct OnboardingViewPreview: View {
    var body: some View {
        OnboardingView(model: .init())
    }
}

#Preview {
    OnboardingViewPreview()
}
#endif
