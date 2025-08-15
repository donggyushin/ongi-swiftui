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
                    
                    PhysicalInfoTextField(
                        placeholder: "예) 170",
                        text: $model.height,
                        suffix: "cm"
                    )
                }
                
                // Weight Input
                VStack(alignment: .leading, spacing: 12) {
                    Text("체중 (kg)")
                        .pretendardBody()
                        .foregroundColor(.primary)
                    
                    PhysicalInfoTextField(
                        placeholder: "예) 65",
                        text: $model.weight,
                        suffix: "kg"
                    )
                }
            }
            
            Spacer()
            
            Button {
                Task {
                    do {
                        try await model.savePhysicalInfo()
                        complete?()
                    } catch {
                        print("Error saving physical info: \(error)")
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

private struct PhysicalInfoTextField: View {
    let placeholder: String
    @Binding var text: String
    let suffix: String
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .pretendardBody()
                .keyboardType(.decimalPad)
                .frame(maxWidth: .infinity)
            
            Text(suffix)
                .pretendardBody()
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    OnboardingPhysicalGenderInfoView(model: .init())
}
