//
//  OnboardingProfileSectionCompletionView.swift
//  Presentation
//
//  Created by 신동규 on 8/16/25.
//

import SwiftUI
import Factory
import Domain

struct OnboardingProfileSectionCompletionView: View {
    
    @State private var showCelebration = false
    @State private var showContent = false
    @State private var showButton = false
    
    var nextAction: (() -> ())?
    func onNextAction(_ action: (() -> ())?) -> Self {
        var copy = self
        copy.nextAction = action
        return copy
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Celebration Section
            VStack(spacing: 32) {
                if showCelebration {
                    VStack(spacing: 16) {
                        // Celebration Icon
                        ZStack {
                            Circle()
                                .fill(.green.opacity(0.1))
                                .frame(width: 100, height: 100)
                                .scaleEffect(showCelebration ? 1.0 : 0.5)
                            
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.green)
                                .scaleEffect(showCelebration ? 1.0 : 0.5)
                        }
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showCelebration)
                        
                        VStack(spacing: 12) {
                            Text("축하합니다! 🎉")
                                .pretendardTitle1()
                                .foregroundColor(.primary)
                                .opacity(showCelebration ? 1.0 : 0.0)
                            
                            Text("프로필 설정이 완료되었어요")
                                .pretendardHeadline()
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .opacity(showCelebration ? 1.0 : 0.0)
                        }
                        .animation(.easeInOut(duration: 0.8).delay(0.3), value: showCelebration)
                    }
                }
                
                if showContent {
                    VStack(spacing: 24) {
                        // Progress Section
                        VStack(spacing: 16) {
                            HStack(spacing: 20) {
                                // Step 1 - Completed
                                stepIndicator(
                                    number: "1", 
                                    title: "프로필", 
                                    subtitle: "완료됨",
                                    isCompleted: true,
                                    isCurrent: false
                                )
                                
                                // Arrow
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.blue)
                                    .font(.headline)
                                
                                // Step 2 - Next
                                stepIndicator(
                                    number: "2", 
                                    title: "자기소개", 
                                    subtitle: "다음 단계",
                                    isCompleted: false,
                                    isCurrent: true
                                )
                            }
                        }
                        .opacity(showContent ? 1.0 : 0.0)
                        
                        // Next Step Description
                        VStack(spacing: 16) {
                            Text("이제 두 번째 단계예요!")
                                .pretendardHeadline()
                                .foregroundColor(.primary)
                            
                            Text("자기소개를 통해 나만의 매력을\n어필해보세요")
                                .pretendardBody()
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .lineSpacing(2)
                        }
                        .opacity(showContent ? 1.0 : 0.0)
                        
                        // Benefits Section
                        VStack(spacing: 12) {
                            benefitRow(
                                icon: "heart.fill",
                                title: "매력 어필",
                                description: "나만의 특별한 면을 보여주세요"
                            )
                            
                            benefitRow(
                                icon: "message.fill",
                                title: "대화 시작점",
                                description: "공통 관심사로 자연스러운 대화를 만들어요"
                            )
                            
                            benefitRow(
                                icon: "sparkles",
                                title: "완벽한 프로필",
                                description: "더 많은 사람들의 관심을 받아보세요"
                            )
                        }
                        .padding(.horizontal, 24)
                        .opacity(showContent ? 1.0 : 0.0)
                    }
                    .animation(.easeInOut(duration: 0.8).delay(0.6), value: showContent)
                }
            }
            
            Spacer()
            
            if showButton {
                VStack(spacing: 16) {
                    Button {
                        nextAction?()
                    } label: {
                        Text("자기소개 작성하기")
                            .pretendardBody(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.accentColor)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 24)
                    .opacity(showButton ? 1.0 : 0.0)
                    
                    Text("조금 더 특별한 나를 보여줄 시간이에요")
                        .pretendardCaption()
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .opacity(showButton ? 1.0 : 0.0)
                }
                .padding(.bottom, 32)
                .animation(.easeInOut(duration: 0.6).delay(1.2), value: showButton)
            }
        }
        .modifier(BackgroundModifier())
        .onAppear {
            startAnimationSequence()
        }
    }
    
    private func stepIndicator(number: String, title: String, subtitle: String, isCompleted: Bool, isCurrent: Bool) -> some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(isCompleted ? .green.opacity(0.1) : (isCurrent ? .blue.opacity(0.1) : .gray.opacity(0.1)))
                    .frame(width: 50, height: 50)
                
                if isCompleted {
                    Image(systemName: "checkmark")
                        .font(.title3)
                        .foregroundColor(.green)
                        .fontWeight(.bold)
                } else {
                    Text(number)
                        .pretendardCallout(.semiBold)
                        .foregroundColor(isCurrent ? .blue : .gray)
                }
            }
            
            VStack(spacing: 2) {
                Text(title)
                    .pretendardCaption1(.medium)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .pretendardCaption2()
                    .foregroundColor(isCompleted ? .green : (isCurrent ? .blue : .secondary))
            }
        }
    }
    
    private func benefitRow(icon: String, title: String, description: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .pretendardCaption1(.medium)
                    .foregroundColor(.primary)
                
                Text(description)
                    .pretendardCaption2()
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
    
    private func startAnimationSequence() {
        // Step 1: Show celebration
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            showCelebration = true
        }
        
        // Step 2: Show content
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.easeInOut(duration: 0.8)) {
                showContent = true
            }
        }
        
        // Step 3: Show button
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            withAnimation(.easeInOut(duration: 0.6)) {
                showButton = true
            }
        }
    }
}

#if DEBUG
#Preview {
    OnboardingProfileSectionCompletionView()
        .preferredColorScheme(.dark)
}
#endif
