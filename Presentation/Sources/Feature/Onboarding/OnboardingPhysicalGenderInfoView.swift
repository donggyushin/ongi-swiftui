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
    
    @State var errorMessage: String?
    
    var complete: (() -> ())?
    func onComplete(_ action: (() -> ())?) -> Self {
        var copy = self
        copy.complete = action
        return copy
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            
            VStack(spacing: 16) {
                Text("신체 정보 입력")
                    .pretendardTitle1()
                    .foregroundColor(.primary)
                
                Text("정확한 매칭을 위해\n신체 정보를 입력해주세요")
                    .pretendardBody()
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 32) {
                // Gender Selection
                VStack(alignment: .leading, spacing: 12) {
                    Text("성별")
                        .pretendardBody()
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 12) {
                        GenderButton(
                            title: "남성",
                            isSelected: model.selectedGender == .male
                        ) {
                            model.selectedGender = .male
                        }
                        
                        GenderButton(
                            title: "여성",
                            isSelected: model.selectedGender == .female
                        ) {
                            model.selectedGender = .female
                        }
                    }
                }
                
                // Height Input
                VStack(alignment: .leading, spacing: 12) {
                    Text("키 (cm)")
                        .pretendardBody()
                        .foregroundColor(.primary)
                    
                    AppTextField(
                        text: $model.height,
                        placeholder: "예) 170",
                        isTextFieldFocused: false
                    )
                    .setSuffix("cm")
                    
                }
                
                // Weight Input
                VStack(alignment: .leading, spacing: 12) {
                    Text("체중 (kg)")
                        .pretendardBody()
                        .foregroundColor(.primary)

                    AppTextField(
                        text: $model.weight,
                        placeholder: "예) 65",
                        isTextFieldFocused: false
                    )
                    .setSuffix("kg")
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
                        try await model.savePhysicalInfo()
                        complete?()
                    } catch AppError.custom(let message, _) {
                        withAnimation {
                            errorMessage = message
                        }
                    }
                }
            } label: {
                AppButton(text: "다음", disabled: !model.isFormValid)
            }
            .disabled(!model.isFormValid)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 34)
        .modifier(BackgroundModifier())
        .loading(model.loading)
        .onAppear {
            Task {
                try await model.fetchInitialInfo()
            }
        }
    }
}

private struct GenderButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .pretendardBody()
                .foregroundColor(isSelected ? .white : .primary)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(isSelected ? Color.accentColor : Color.gray.opacity(0.1))
                .cornerRadius(12)
        }
    }
}

#Preview {
    OnboardingPhysicalGenderInfoView(model: .init())
}
