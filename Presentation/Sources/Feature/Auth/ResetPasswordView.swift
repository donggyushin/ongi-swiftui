//
//  ResetPasswordView.swift
//  Presentation
//
//  Created by 신동규 on 9/3/25.
//

import SwiftUI
import Domain

struct ResetPasswordView: View {
    
    @StateObject var model: ResetPasswordViewModel
    @State private var errorMessage: String?
    @State private var verifyCodeMode = true
    @State private var passwordConfirm = ""
    @Environment(\.dismiss) private var dismiss
    
    @FocusState private var focus
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            if verifyCodeMode {
                // Header Section
                headerSection
                
                Spacer()
                
                // Input Section
                VStack(spacing: 24) {
                    verificationCodeInputField
                    confirmButton
                    resendCodeButton
                }
                .padding(.horizontal, 24)
            } else {
                // Header Section
                passwordResetHeaderSection
                
                Spacer()
                
                // Input Section
                VStack(spacing: 24) {
                    passwordInputField
                    passwordConfirmInputField
                    resetPasswordButton
                }
                .padding(.horizontal, 24)
            }
            
            if let errorMessage = errorMessage {
                errorMessageView(errorMessage)
                    .padding()
            }
            
            Spacer()
        }
        .modifier(BackgroundModifier())
        .navigationBarTitleDisplayMode(.inline)
        .loading(model.loading)
        .task {
            try? await model.requestVerificationCode()
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Text("인증번호를 입력해주세요")
                .pretendardTitle1()
                .foregroundColor(.primary)
            
            Text("이메일로 전송된 6자리 인증번호를\n입력해주세요")
                .pretendardBody()
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var verificationCodeInputField: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("인증번호")
                    .pretendardBody()
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(String(format: "%d:%02d", Int(model.leftTimeInterval) / 60, Int(model.leftTimeInterval) % 60))")
                    .pretendardCaption()
                    .foregroundColor(model.leftTimeInterval > 0 ? .blue : .red)
            }
            
            TextField("인증번호 6자리를 입력하세요", text: $model.code)
                .keyboardType(.numberPad)
                .padding(16)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .pretendardBody()
                .focused($focus)
                .onAppear {
                    focus = true
                }
        }
    }
    
    private var confirmButton: some View {
        Button {
            Task {
                do {
                    try await model.verifyCode()
                    withAnimation {
                        verifyCodeMode = false
                    }
                } catch AppError.custom(let message, code: _) {
                    withAnimation {
                        errorMessage = message
                    }
                }
            }
        } label: {
            Text("확인")
                .pretendardBody()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(model.code.count == 6 ? Color.blue : Color(.systemGray4))
                .cornerRadius(12)
        }
        .disabled(model.code.count != 6)
    }
    
    private var resendCodeButton: some View {
        Button {
            Task {
                do {
                    try await model.requestVerificationCode()
                } catch AppError.custom(let message, _) {
                    withAnimation {
                        errorMessage = message
                    }
                }
            }
        } label: {
            Text("인증번호 재발송")
                .pretendardCaption()
                .foregroundColor(.blue)
                .underline()
        }
        .disabled(model.leftTimeInterval > 0)
    }
    
    private var passwordResetHeaderSection: some View {
        VStack(spacing: 16) {
            Text("새 비밀번호를 설정해주세요")
                .pretendardTitle1()
                .foregroundColor(.primary)
            
            Text("새로운 비밀번호를 입력하고\n확인해주세요")
                .pretendardBody()
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var passwordInputField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("새 비밀번호")
                .pretendardBody()
                .foregroundColor(.primary)
            
            SecureField("새 비밀번호를 입력하세요", text: $model.password)
                .padding(16)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .pretendardBody()
        }
    }
    
    private var passwordConfirmInputField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("비밀번호 확인")
                .pretendardBody()
                .foregroundColor(.primary)
            
            SecureField("비밀번호를 다시 입력하세요", text: $passwordConfirm)
                .padding(16)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .pretendardBody()
        }
    }
    
    private var resetPasswordButton: some View {
        Button {
            Task {
                do {
                    guard model.password == passwordConfirm else {
                        withAnimation {
                            errorMessage = "비밀번호가 일치하지 않습니다."
                        }
                        return
                    }
                    
                    try await model.resetPassword()
                } catch AppError.custom(let message, code: _) {
                    withAnimation {
                        errorMessage = message
                    }
                } catch {
                    withAnimation {
                        errorMessage = "비밀번호 재설정에 실패했습니다."
                    }
                }
            }
        } label: {
            Text("비밀번호 재설정")
                .pretendardBody()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(isValidPassword ? Color.blue : Color(.systemGray4))
                .cornerRadius(12)
        }
        .disabled(!isValidPassword)
    }
    
    private var isValidPassword: Bool {
        !model.password.isEmpty && !passwordConfirm.isEmpty && model.password == passwordConfirm
    }
    
    private func errorMessageView(_ message: String) -> some View {
        HStack {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundColor(.red)
                .font(.system(size: 16))
            
            Text(message)
                .pretendardCaption()
                .foregroundColor(.red)
            
            Spacer()
        }
        .padding(12)
        .background(Color.red.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    ResetPasswordView(model: .init(email: "user@example.com"))
}
