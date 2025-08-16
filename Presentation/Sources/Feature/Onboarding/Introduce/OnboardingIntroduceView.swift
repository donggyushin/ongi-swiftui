//
//  OnboardingIntroduceView.swift
//  Presentation
//
//  Created by 신동규 on 8/16/25.
//

import SwiftUI
import Domain

struct OnboardingIntroduceView: View {
    
    @StateObject var model: OnboardingIntroduceViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 12) {
                Text("간단한 자기소개를 작성해주세요")
                    .pretendardTitle1()
                    .foregroundColor(.primary)
                
                Text("나를 표현할 수 있는 매력적인 소개를 써보세요")
                    .pretendardBody()
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 40)
            
            VStack(alignment: .leading, spacing: 8) {
                ZStack(alignment: .topLeading) {
                    
                    
                    if model.introduceText.isEmpty {
                        Text("예: 안녕하세요! 새로운 사람들과 만나는 것을 좋아하는 활발한 성격입니다. 함께 좋은 시간을 보내고 싶어요.")
                            .pretendardBody()
                            .foregroundColor(.gray)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .allowsHitTesting(false)
                    }
                    
                    TextEditor(text: $model.introduceText)
                        .pretendardBody()
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        }
                }
                
                HStack {
                    
                    if model.characterCount > 0 && model.characterCount < 100 {
                        Text("100자 이상 작성해주세요")
                            .pretendardCaption1()
                            .foregroundStyle(.orange)
                    }
                    
                    Spacer()
                    Text("\(model.characterCount)/\(model.maxCharacterCount)")
                        .pretendardCaption1()
                        .foregroundColor(model.remainingCharacters >= 0 ? .gray : .red)
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            Button {
                // TODO: Handle completion
            } label: {
                AppButton(text: "다음", disabled: !model.isValidIntroduce || model.isLoading)
                
            }
            .disabled(!model.isValidIntroduce || model.isLoading)
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal, 20)
            .padding(.bottom, 34)
        }
        .modifier(BackgroundModifier())
        .onTapGesture {
            hideKeyboard()
        }
        .loading(model.isLoading)
        .onAppear {
            Task {
                try await model.fetchInitialData()
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    OnboardingIntroduceView(model: .init())
}
