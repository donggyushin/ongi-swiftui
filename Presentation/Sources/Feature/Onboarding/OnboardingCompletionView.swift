//
//  OnboardingCompletionView.swift
//  Presentation
//
//  Created by 신동규 on 8/17/25.
//

import SwiftUI
import Factory
import Domain

struct OnboardingCompletionView: View {
    
    @State private var showCelebration = false
    @State private var showContent = false
    @State private var showButton = false
    @State private var showFireworks = false
    
    var onStart: (() -> ())?
    func onStart(_ action: (() -> ())?) -> Self {
        var copy = self
        copy.onStart = action
        return copy
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Celebration Section
            VStack(spacing: 32) {
                if showCelebration {
                    VStack(spacing: 16) {
                        // Celebration Icon with Fireworks Effect
                        ZStack {
                            // Background Circle
                            Circle()
                                .fill(.green.opacity(0.1))
                                .frame(width: 120, height: 120)
                                .scaleEffect(showCelebration ? 1.0 : 0.5)
                            
                            // Fireworks Effect
                            if showFireworks {
                                ForEach(0..<8, id: \.self) { index in
                                    Circle()
                                        .fill(.yellow.opacity(0.8))
                                        .frame(width: 8, height: 8)
                                        .offset(
                                            x: cos(Double(index) * .pi / 4) * 80,
                                            y: sin(Double(index) * .pi / 4) * 80
                                        )
                                        .scaleEffect(showFireworks ? 1.0 : 0.0)
                                        .opacity(showFireworks ? 0.0 : 1.0)
                                }
                            }
                            
                            // Main Icon
                            Image(systemName: "party.popper.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.green)
                                .scaleEffect(showCelebration ? 1.0 : 0.5)
                        }
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showCelebration)
                        .animation(.easeOut(duration: 1.2), value: showFireworks)
                        
                        VStack(spacing: 12) {
                            Text("온기 가입 완료! 🎉")
                                .pretendardTitle1()
                                .foregroundColor(.primary)
                                .opacity(showCelebration ? 1.0 : 0.0)
                            
                            Text("모든 설정이 완료되었어요\n이제 새로운 인연을 만나볼까요?")
                                .pretendardHeadline()
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .lineSpacing(2)
                                .opacity(showCelebration ? 1.0 : 0.0)
                        }
                        .animation(.easeInOut(duration: 0.8).delay(0.3), value: showCelebration)
                    }
                }
                
                if showContent {
                    VStack(spacing: 24) {
                        // All Steps Completed Section
                        VStack(spacing: 16) {
                            HStack(spacing: 15) {
                                // Step 1 - Completed
                                stepIndicator(
                                    number: "1", 
                                    title: "프로필", 
                                    subtitle: "완료",
                                    isCompleted: true,
                                    isCurrent: false
                                )
                                
                                // Arrow
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.green)
                                    .font(.caption)
                                
                                // Step 2 - Completed
                                stepIndicator(
                                    number: "2", 
                                    title: "자기소개", 
                                    subtitle: "완료",
                                    isCompleted: true,
                                    isCurrent: false
                                )
                                
                                // Arrow
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.green)
                                    .font(.caption)
                                
                                // Step 3 - Completed
                                stepIndicator(
                                    number: "3", 
                                    title: "이메일 인증", 
                                    subtitle: "완료",
                                    isCompleted: true,
                                    isCurrent: false
                                )
                            }
                            .padding(.horizontal, 20)
                        }
                        .opacity(showContent ? 1.0 : 0.0)
                        
                        // Completion Summary
                        VStack(spacing: 16) {
                            Text("준비가 모두 끝났어요!")
                                .pretendardHeadline()
                                .foregroundColor(.primary)
                            
                            Text("완성된 프로필로 온기에서\n특별한 인연을 만나보세요")
                                .pretendardBody()
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .lineSpacing(2)
                        }
                        .opacity(showContent ? 1.0 : 0.0)
                        
                        // Achievement Section
                        VStack(spacing: 12) {
                            achievementRow(
                                icon: "checkmark.seal.fill",
                                title: "인증 완료",
                                description: "신뢰할 수 있는 프로필이 준비되었어요"
                            )
                            
                            achievementRow(
                                icon: "heart.circle.fill",
                                title: "매칭 준비",
                                description: "이제 다른 사용자들과 매칭을 시작할 수 있어요"
                            )
                            
                            achievementRow(
                                icon: "star.circle.fill",
                                title: "온기 시작",
                                description: "따뜻한 인연이 기다리고 있어요"
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
                        onStart?()
                    } label: {
                        HStack {
                            Image(systemName: "heart.fill")
                                .font(.title3)
                            
                            Text("온기 시작하기")
                                .pretendardBody(.bold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.accentColor, Color.accentColor.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                        .shadow(color: Color.accentColor.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 24)
                    .opacity(showButton ? 1.0 : 0.0)
                    .scaleEffect(showButton ? 1.0 : 0.9)
                    
                    Text("새로운 시작을 축하드려요! ✨")
                        .pretendardCaption()
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .opacity(showButton ? 1.0 : 0.0)
                }
                .padding(.bottom, 32)
                .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(1.2), value: showButton)
            }
        }
        .modifier(BackgroundModifier())
        .onAppear {
            startAnimationSequence()
        }
    }
    
    private func stepIndicator(number: String, title: String, subtitle: String, isCompleted: Bool, isCurrent: Bool) -> some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(.green.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: "checkmark")
                    .font(.caption)
                    .foregroundColor(.green)
                    .fontWeight(.bold)
            }
            
            VStack(spacing: 1) {
                Text(title)
                    .pretendardCaption2(.medium)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .pretendardCaption2()
                    .foregroundColor(.green)
                    .font(.system(size: 10))
            }
        }
    }
    
    private func achievementRow(icon: String, title: String, description: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.green)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
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
        
        // Step 1.5: Show fireworks
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.easeOut(duration: 1.2)) {
                showFireworks = true
            }
        }
        
        // Step 2: Show content
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeInOut(duration: 0.8)) {
                showContent = true
            }
        }
        
        // Step 3: Show button
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                showButton = true
            }
        }
    }
}

#if DEBUG
#Preview {
    OnboardingCompletionView()
        .preferredColorScheme(.dark)
}
#endif
