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
    
    public init(model: OnboardingViewModel) {
        self._model = .init(wrappedValue: model)
    }
    
    public var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 0) {
                        // Header Section
                        headerSection
                            .frame(height: geometry.size.height * 0.35)
                        
                        // Content Section  
                        contentSection
                            .padding(.horizontal, 24)
                            .frame(minHeight: geometry.size.height * 0.5)
                        
                        Spacer()
                        
                        // Action Button
                        actionButton
                            .padding(.horizontal, 24)
                            .padding(.bottom, 40)
                    }
                }
            }
            .background(
                LinearGradient(
                    colors: [
                        Color(.systemBackground),
                        Color(.systemGray6)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .ignoresSafeArea()
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // App Icon
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 80, height: 80)
                .overlay(
                    Text("온")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                )
            
            VStack(spacing: 12) {
                Text("환영합니다!")
                    .pretendardTitle1()
                    .foregroundColor(.primary)
                
                Text("온기에서 따뜻한 소통을 시작해보세요")
                    .pretendardBody()
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
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
                Text("간단한 3단계로 완성해요")
                    .pretendardHeadline()
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 20) {
                    stepItem(number: "1", title: "이메일 인증", subtitle: "안전한 계정")
                    stepItem(number: "2", title: "프로필 사진", subtitle: "나를 표현하기")
                    stepItem(number: "3", title: "자기 소개", subtitle: "매력 어필하기")
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
        Button(action: {
            // TODO: Start onboarding flow
        }) {
            HStack {
                Text("시작하기")
                    .pretendardCallout(.semiBold)
                    .foregroundColor(.white)
                
                Image(systemName: "arrow.right")
                    .font(.callout)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(.blue)
            .cornerRadius(12)
        }
    }
}

#if DEBUG
private struct OnboardingViewPreview: View {
    var body: some View {
        OnboardingView(model: Container.shared.onboardingViewModel())
    }
}

#Preview {
    OnboardingViewPreview()
}
#endif
