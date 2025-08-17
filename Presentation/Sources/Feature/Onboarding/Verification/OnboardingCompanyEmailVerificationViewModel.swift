//
//  OnboardingCompanyEmailVerificationViewModel.swift
//  Presentation
//
//  Created by 신동규 on 8/17/25.
//

import Domain
import Factory
import SwiftUI
import Combine

final class OnboardingCompanyEmailVerificationViewModel: ObservableObject {
    
    @Published var loading = false
    @Published var companyEmail = ""
    @Published var verificationCode = "" // 6 digits
    
    @Published var showCodeInput = false
    
    var expiredDate: Date?
    
    @Published var verificationLeftTime: Int = 300
    
    let authUseCase = Container.shared.authUseCase()
    private var timer: AnyCancellable?
    
    init() { }
    
    @MainActor
    func sendVerificationCodeToEmail() async throws {
        loading = true
        defer { loading = false }
        
        try await authUseCase.sendVerificationCode(companyEmail: companyEmail)
        withAnimation {
            showCodeInput = true
        }
        expiredDate = Date() + 300
        verificationLeftTime = 300
        startTimer()
    }
    
    @MainActor
    func verifyEmail() async throws {
        loading = true
        defer { loading = false }
        
        try await authUseCase.verifyEmailVerificationCode(code: verificationCode)
        stopTimer()
    }
    
    @MainActor
    func reset() {
        stopTimer()
        withAnimation {
            companyEmail = ""
            verificationCode = ""
            showCodeInput = false
            expiredDate = nil
            verificationLeftTime = 300
        }
    }
    
    private func startTimer() {
        stopTimer()
        timer = Timer.publish(every: 0.5, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if let expiredDate = self.expiredDate {
                        self.verificationLeftTime = Int(expiredDate.timeIntervalSince1970 - Date().timeIntervalSince1970)
                    } else {
                        self.verificationLeftTime = 300
                        self.stopTimer()
                    }
                }
            }
    }
    
    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }
    
    deinit {
        stopTimer()
    }
}
