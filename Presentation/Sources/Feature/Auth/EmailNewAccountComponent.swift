//
//  EmailNewAccountComponent.swift
//  Presentation
//
//  Created by 신동규 on 9/1/25.
//

import SwiftUI

struct EmailNewAccountComponent: View {
    
    @StateObject var model: EmailNewAccountComponentModel
    
    var passwordCompletion: ((String) -> ())?
    func onPasswordCompletion(_ action: ((String) -> ())?) -> Self {
        var copy = self
        copy.passwordCompletion = action
        return copy
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Header Section
            headerSection
            
            // Password Input Fields
            VStack(spacing: 16) {
                passwordField
                confirmPasswordField
            }
            
            // Complete Button
            completeButton
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("비밀번호를 설정해주세요")
                .pretendardTitle2()
                .foregroundColor(.primary)
            
            Text("안전한 계정을 위해 비밀번호를 입력해주세요")
                .pretendardBody()
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var passwordField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("비밀번호")
                .pretendardBody()
                .foregroundColor(.primary)
            
            SecureField("비밀번호를 입력하세요", text: $model.pw1)
                .padding(16)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .pretendardBody()
        }
    }
    
    private var confirmPasswordField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("비밀번호 확인")
                .pretendardBody()
                .foregroundColor(.primary)
            
            SecureField("비밀번호를 다시 입력하세요", text: $model.pw2)
                .padding(16)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .pretendardBody()
            
            if let errorMessage = model.errorMessage {
                Text(errorMessage)
                    .pretendardCaption()
                    .foregroundColor(.red)
                    .padding(.top, 4)
            }
        }
    }
    
    private var completeButton: some View {
        Button {
            passwordCompletion?(model.pw1)
        } label: {
            Text("계정 생성")
                .pretendardBody()
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, minHeight: 50)
        .background(model.isButtonEnabled ? Color.blue : Color(.systemGray4))
        .cornerRadius(12)
        .disabled(!model.isButtonEnabled)
    }
}
