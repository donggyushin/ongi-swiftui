//
//  EmailInputView.swift
//  Presentation
//
//  Created by 신동규 on 9/1/25.
//

import SwiftUI
import Domain

struct EmailInputView: View {
    
    @StateObject var model: EmailInputViewModel
    
    @State var loginFlow = false
    @State var newAccountFlow = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Header Section
            headerSection
            
            Spacer()
            
            // Input Section
            VStack(spacing: 24) {
                
                if loginFlow == false && newAccountFlow == false {
                    emailInputField
                    nextButton
                } else {
                    emailDisplaySection
                }
                
                if newAccountFlow {
                    EmailNewAccountComponent(model: .init())
                        .onPasswordCompletion { password in
                            Task {
                                do {
                                    try await model.makeNewAccount(pw: password)
                                } catch AppError.custom(let message, code: _) {
                                    withAnimation {
                                        model.errorMessage = message
                                    }
                                }
                            }
                        }
                }
                
                if loginFlow {
                    EmailLoginComponent()
                        .onPasswordCompletion { password in
                            Task {
                                do {
                                    try await model.login(pw: password)
                                } catch AppError.custom(let message, code: _) {
                                    withAnimation {
                                        model.errorMessage = message
                                    }
                                }
                            }
                        }
                }
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
            Task {
                do {
                    let _ = try await model.searchAccount()
                    withAnimation {
                        loginFlow = true
                    }
                } catch {
                    withAnimation {
                        newAccountFlow = true
                    }
                }
            }
        } label: {
            Text("다음")
                .pretendardBody()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(model.isNextButtonEnabled ? Color.blue : Color(.systemGray4))
                .cornerRadius(12)
        }
        .disabled(!model.isNextButtonEnabled)
    }
    
    private var emailDisplaySection: some View {
        HStack {
            Image(systemName: "envelope.fill")
                .foregroundColor(.blue)
                .font(.system(size: 16))
            
            Text(model.email)
                .pretendardBody()
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(16)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    EmailInputView(model: .init())
}
