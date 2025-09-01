//
//  EmailInputViewModel.swift
//  Presentation
//
//  Created by 신동규 on 9/1/25.
//

import SwiftUI
import Domain
import Combine
import Factory

final class EmailInputViewModel: ObservableObject {
    @Published var email = ""
    @Published var errorMessage: String?
    @Published var isNextButtonEnabled: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        bind()
    }
    
    private func bind() {
        $email
            .map { [weak self] email in
                self?.validateEmail(email) ?? false
            }
            .assign(to: &$isNextButtonEnabled)
        
        $email
            .map { [weak self] email in
                self?.getEmailErrorMessage(email)
            }
            .assign(to: &$errorMessage)
    }
    
    private func validateEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9+_.-]+@([A-Za-z0-9.-]+\\.[A-Za-z]{2,})$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    private func getEmailErrorMessage(_ email: String) -> String? {
        guard !email.isEmpty else { return nil }
        
        if !validateEmail(email) {
            return "올바른 이메일 형식을 입력해주세요"
        }
        
        return nil
    }
}
