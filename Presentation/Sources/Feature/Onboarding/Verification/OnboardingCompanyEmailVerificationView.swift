//
//  OnboardingCompanyEmailVerificationView.swift
//  Presentation
//
//  Created by 신동규 on 8/17/25.
//

import SwiftUI

struct OnboardingCompanyEmailVerificationView: View {
    
    @StateObject var model: OnboardingCompanyEmailVerificationViewModel
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showCodeInput = false
    @State private var timer: Timer?
    
    var onNext: (() -> ())?
    func onNext(_ action: (() -> ())?) -> Self {
        var copy = self
        copy.onNext = action
        return copy
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header Section
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    // Icon
                    ZStack {
                        Circle()
                            .fill(.blue.opacity(0.1))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "envelope.badge.shield.half.filled")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                    }
                    
                    VStack(spacing: 12) {
                        Text("회사 이메일 인증")
                            .pretendardTitle1()
                            .foregroundColor(.primary)
                        
                        Text("신뢰할 수 있는 회사 이메일로\n계정을 인증해주세요")
                            .pretendardBody()
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(2)
                    }
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
                        
                        benefitRow(
                            icon: "building.2.fill",
                            title: "직장 정보 확인",
                            description: "회사 이메일을 통해 직장 정보를 안전하게 확인해요"
                        )
                        
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
                
                // Verification Code Input (shown after email sent)
                if showCodeInput {
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
                        }
                        
                        // Verify Button
                        Button {
                            Task {
                                await verifyCode()
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
                                await sendVerificationEmail()
                            }
                        } label: {
                            Text("인증 코드 재전송")
                                .pretendardBody()
                                .foregroundColor(.blue)
                                .underline()
                        }
                        .disabled(model.loading || model.verificationLeftTime > 240) // Allow resend after 1 minute
                    }
                } else {
                    // Send Button
                    Button {
                        Task {
                            await sendVerificationEmail()
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
        .alert("알림", isPresented: $showAlert) {
            Button("확인") { }
        } message: {
            Text(alertMessage)
        }
        .onDisappear {
            timer?.invalidate()
        }
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
    
    private func sendVerificationEmail() async {
        guard isValidEmail else {
            alertMessage = "올바른 회사 이메일 주소를 입력해주세요."
            showAlert = true
            return
        }
        
        do {
            try await model.sendVerificationCodeToEmail()
            
            await MainActor.run {
                alertMessage = "인증 이메일이 발송되었습니다.\n이메일을 확인해주세요."
                showAlert = true
                showCodeInput = true
                startTimer()
            }
        } catch {
            await MainActor.run {
                alertMessage = error.localizedDescription
                showAlert = true
            }
        }
    }
    
    private func verifyCode() async {
        guard isValidCode else {
            alertMessage = "6자리 인증 코드를 입력해주세요."
            showAlert = true
            return
        }
        
        do {
            try await model.verifyEmail()
            
            await MainActor.run {
                timer?.invalidate()
                alertMessage = "이메일 인증이 완료되었습니다!"
                showAlert = true
                // Navigate to next step after alert
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    onNext?()
                }
            }
        } catch {
            await MainActor.run {
                alertMessage = error.localizedDescription
                showAlert = true
            }
        }
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if model.verificationLeftTime > 0 {
                model.verificationLeftTime -= 1
            } else {
                timer?.invalidate()
            }
        }
    }
}

#if DEBUG
#Preview {
    OnboardingCompanyEmailVerificationView(model: .init())
        .preferredColorScheme(.dark)
}
#endif
