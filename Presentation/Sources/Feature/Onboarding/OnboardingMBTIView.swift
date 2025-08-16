//
//  OnboardingMBTIView.swift
//  Presentation
//
//  Created by 신동규 on 8/16/25.
//

import Domain
import Factory
import SwiftUI

struct OnboardingMBTIView: View {
    
    @StateObject var model: OnboardingMBTIViewModel
    
    var complete: (() -> ())?
    func onComplete(_ action: (() -> ())?) -> Self {
        var copy = self
        copy.complete = action 
        return copy
    }
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 12) {
                Text("MBTI를 선택해주세요")
                    .pretendardTitle1()
                    .foregroundColor(.primary)
                
                Text("성격 유형을 바탕으로 더 나은 매칭을 도와드려요")
                    .pretendardBody()
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 40)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
                ForEach(model.mbtiOptions, id: \.self) { mbti in
                    Button {
                        model.selectMBTI(mbti)
                    } label: {
                        Text(model.mbtiDisplayText(mbti))
                            .pretendardTitle3()
                            .foregroundColor(model.selectedMBTI == mbti ? .white : .primary)
                            .frame(height: 56)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(model.selectedMBTI == mbti ? Color.blue : Color.gray.opacity(0.1))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(model.selectedMBTI == mbti ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            Button {
                // TODO: Handle completion
            } label: {
                AppButton(text: "다음", disabled: model.selectedMBTI == nil)
            }
            .disabled(model.selectedMBTI == nil)
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal, 20)
            .padding(.bottom, 34)
        }
        .modifier(BackgroundModifier())
        
    }
}

#Preview {
    OnboardingMBTIView(model: .init())
}
