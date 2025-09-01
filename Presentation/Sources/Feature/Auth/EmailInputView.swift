//
//  EmailInputView.swift
//  Presentation
//
//  Created by 신동규 on 9/1/25.
//

import SwiftUI

struct EmailInputView: View {
    
    @StateObject var model: EmailInputViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Header Section
            headerSection
            
            Spacer()
            
            // Input Section
            VStack(spacing: 24) {
                emailInputField
                nextButton
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .modifier(BackgroundModifier())
        .navigationBarTitleDisplayMode(.inline)
        .loading(model.loading)
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Text("이메일을 입력해주세요")
                .pretendardTitle1()
                .foregroundColor(.primary)
            
            Text("계정 생성 또는 로그인을 위해\n이메일 주소가 필요합니다")
                .pretendardBody()
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var emailInputField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("이메일")
                .pretendardBody()
                .foregroundColor(.primary)
            
            TextField("이메일을 입력하세요", text: $model.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
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
    
    private var nextButton: some View {
        Button {
            // 다음 단계 로직 구현 예정
        } label: {
            Text("다음")
                .pretendardBody()
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, minHeight: 50)
        .background(Color.blue)
        .cornerRadius(12)
        .disabled(!model.isNextButtonEnabled)
    }
}

#Preview {
    EmailInputView(model: .init())
}
