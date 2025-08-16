//
//  OnboardingNicknameView.swift
//  Presentation
//
//  Created by 신동규 on 8/16/25.
//

import Factory
import SwiftUI
import Domain

struct OnboardingNicknameView: View {
    
    @StateObject var model: OnboardingNicknameViewModel
    @FocusState private var isTextFieldFocused: Bool
    
    var nextAction: (() -> ())?
    func onNextAction(_ action: (() -> ())?) -> Self {
        var copy = self
        copy.nextAction = action
        return copy
    }
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 16) {
                Text("닉네임을 입력해주세요")
                    .pretendardTitle1()
                    .multilineTextAlignment(.center)
                
                Text("다른 사용자들에게 보여질 이름이에요")
                    .pretendardBody()
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 40)
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("닉네임")
                        .pretendardBody(.medium)
                        .foregroundColor(.primary)
                    
                    TextField("2-10자 이내로 입력", text: $model.nickname)
                        .pretendardBody()
                        .textFieldStyle(.plain)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray6))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(isTextFieldFocused ? Color.accentColor : Color.clear, lineWidth: 2)
                                )
                        )
                        .focused($isTextFieldFocused)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .onChange(of: model.nickname) { _ in
                            model.errorMessage = nil
                        }
                    
                    HStack {
                        Text("\(model.nickname.count)/10")
                            .pretendardCaption()
                            .foregroundColor(model.nickname.count > 10 ? .red : .secondary)
                        
                        Spacer()
                        
                        if model.isNicknameValid {
                            HStack(spacing: 4) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("사용 가능")
                                    .pretendardCaption()
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                if let errorMessage = model.errorMessage {
                    Text(errorMessage)
                        .pretendardCaption()
                        .foregroundColor(.red)
                        .padding(.horizontal, 24)
                        .transition(.opacity)
                }
            }
            
            Spacer()
            
            VStack(spacing: 16) {
                Button {
                    Task {
                        do {
                            try await model.updateNickname()
                            if model.errorMessage == nil {
                                nextAction?()
                            }
                        } catch AppError.custom(let message, code: _) {
                            withAnimation {
                                model.errorMessage = message
                            }
                        } catch {
                            withAnimation {
                                model.errorMessage = "닉네임 업데이트에 실패했습니다. 다시 시도해주세요."
                            }
                        }
                    }
                } label: {
                    Text("계속하기")
                        .pretendardBody(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            model.isNicknameValid ? Color.accentColor : Color.gray
                        )
                        .cornerRadius(12)
                }
                .disabled(!model.isNicknameValid || model.loading)
                .padding(.horizontal, 24)
                
                Text("닉네임은 나중에 프로필에서 변경할 수 있어요")
                    .pretendardCaption()
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.bottom, 32)
        }
        .modifier(BackgroundModifier())
        .onAppear {
            Task {
                try await model.fetchCurrentNickname()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isTextFieldFocused = true
            }
        }
        .loading(model.loading)
        .onTapGesture {
            isTextFieldFocused = false
        }
    }
}

#if DEBUG
#Preview {
    OnboardingNicknameView(model: .init())
}
#endif
