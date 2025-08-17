//
//  OnboardingCompanyEmailVerificationView.swift
//  Presentation
//
//  Created by 신동규 on 8/17/25.
//

import SwiftUI
import Domain

struct OnboardingCompanyEmailVerificationView: View {
    
    @StateObject var model: OnboardingCompanyEmailVerificationViewModel
    @State var errorMessage: String?
    @FocusState var verificationCodeFocus
    
    var onNext: (() -> ())?
    func onNext(_ action: (() -> ())?) -> Self {
        var copy = self
        copy.onNext = action
        return copy
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header Section
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(.blue.opacity(0.1))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "envelope.badge.shield.half.filled")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                }
                
                // Benefits Section
                VStack(spacing: 16) {
                    HStack {
                        Text("이메일 인증의 장점")
                            .pretendardHeadline()
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    
                    VStack(spacing: 12) {
                        benefitRow(
                            icon: "checkmark.shield.fill",
                            title: "신뢰도 향상",
                            description: "인증된 회사 이메일로 다른 유저들에게 신뢰감을 줄 수 있어요"
                        )
                        
//                        benefitRow(
//                            icon: "building.2.fill",
//                            title: "직장 정보 확인",
//                            description: "회사 이메일을 통해 직장 정보를 안전하게 확인해요"
//                        )
                        
                        benefitRow(
                            icon: "person.2.fill",
                            title: "매칭 우선권",
                            description: "인증된 계정은 더 많은 매칭 기회를 받을 수 있어요"
                        )
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 40)
            
            Spacer()
            
            // Email Input Section
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("회사 이메일 주소")
                                .pretendardCallout(.medium)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Text("필수")
                                .pretendardCaption2()
                                .foregroundColor(.red)
                        }
                        
                        TextField("예: name@company.com", text: $model.companyEmail)
                            .pretendardBody()
                            .textFieldStyle(PlainTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                            .padding(16)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(model.companyEmail.isEmpty ? Color.clear : .blue, lineWidth: 1)
                            )
                    }
                    
                    // Important Notice
                    if let errorMessage {
                        HStack(spacing: 8) {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.red)
                                .font(.caption)
                            
                            Text(errorMessage)
                                .pretendardCaption1()
                                .foregroundColor(.secondary)
                            
                            Spacer()
                        }
                        .padding(12)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                    } else {
                        HStack(spacing: 8) {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.orange)
                                .font(.caption)
                            
                            Text("개인 이메일(Gmail, Naver 등)은 인증이 불가해요")
                                .pretendardCaption1()
                                .foregroundColor(.secondary)
                            
                            Spacer()
                        }
                        .padding(12)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                
                // Verification Code Input (shown after email sent)
                if model.showCodeInput {
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("인증 코드")
                                    .pretendardCallout(.medium)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Text(timeString)
                                    .pretendardCaption2()
                                    .foregroundColor(model.verificationLeftTime > 60 ? .blue : .red)
                            }
                            
                            TextField("6자리 인증 코드", text: $model.verificationCode)
                                .pretendardBody()
                                .textFieldStyle(PlainTextFieldStyle())
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                                .padding(16)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(model.verificationCode.isEmpty ? Color.clear : .blue, lineWidth: 1)
                                )
                                .onAppear {
                                    Task {
                                        try await Task.sleep(for: .seconds(0.7))
                                        verificationCodeFocus = true
                                    }
                                }
                                .focused($verificationCodeFocus)
                        }
                        
                        // Verify Button
                        Button {
                            Task {
                                do {
                                    withAnimation {
                                        errorMessage = nil
                                    }
                                    try await model.verifyEmail()
                                    onNext?()
                                } catch AppError.custom(let message, code: _) {
                                    withAnimation {
                                        errorMessage = message
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                if model.loading {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                }
                                
                                Text(model.loading ? "인증 중..." : "인증 완료")
                                    .pretendardBody(.bold)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(isValidCode ? Color.accentColor : Color.gray)
                            .cornerRadius(12)
                        }
                        .disabled(!isValidCode || model.loading)
                        
                        // Resend Button
                        Button {
                            Task {
                                model.reset()
                                verificationCodeFocus = false
                            }
                        } label: {
                            Text("인증 코드 재전송")
                                .pretendardBody()
                                .foregroundColor(.blue)
                                .underline()
                        }
                    }
                } else {
                    // Send Button
                    Button {
                        Task {
                            do {
                                withAnimation {
                                    errorMessage = nil
                                }
                                try await model.sendVerificationCodeToEmail()
                            } catch AppError.custom(let message, code: _) {
                                withAnimation {
                                    errorMessage = message
                                }
                            }
                        }
                    } label: {
                        HStack {
                            if model.loading {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                            
                            Text(model.loading ? "전송 중..." : "인증 이메일 받기")
                                .pretendardBody(.bold)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(isValidEmail ? Color.accentColor : Color.gray)
                        .cornerRadius(12)
                    }
                    .disabled(!isValidEmail || model.loading)
                }
                
                // Skip Option
                Button {
                    onNext?()
                } label: {
                    Text("나중에 인증하기")
                        .pretendardBody()
                        .foregroundColor(.secondary)
                        .underline()
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .modifier(BackgroundModifier())
    }
    
    private func benefitRow(icon: String, title: String, description: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
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
    
    private var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: model.companyEmail) && !isPersonalEmail
    }
    
    private var isPersonalEmail: Bool {
        let personalDomains = ["gmail.com", "naver.com", "daum.net", "kakao.com", "yahoo.com", "hotmail.com", "outlook.com", "icloud.com"]
        let domain = model.companyEmail.split(separator: "@").last?.lowercased() ?? ""
        return personalDomains.contains(String(domain))
    }
    
    private var isValidCode: Bool {
        model.verificationCode.count == 6 && model.verificationCode.allSatisfy { $0.isNumber }
    }
    
    private var timeString: String {
        let minutes = model.verificationLeftTime / 60
        let seconds = model.verificationLeftTime % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#if DEBUG
#Preview {
    OnboardingCompanyEmailVerificationView(model: .init())
        .preferredColorScheme(.dark)
}
#endif
