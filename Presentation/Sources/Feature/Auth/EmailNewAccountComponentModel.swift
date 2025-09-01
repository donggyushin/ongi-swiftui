//
//  EmailNewAccountComponentModel.swift
//  Presentation
//
//  Created by 신동규 on 9/1/25.
//

import SwiftUI
import Domain
import Combine
import Factory

final class EmailNewAccountComponentModel: ObservableObject {
    
    @Published var pw1 = ""
    @Published var pw2 = ""
    
    @Published var isButtonEnabled = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        bind()
    }
    
    private func bind() {
        Publishers.CombineLatest($pw1, $pw2)
            .map { [weak self] pw1, pw2 in
                self?.validatePasswords(pw1: pw1, pw2: pw2) ?? false
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$isButtonEnabled)
        
        Publishers.CombineLatest($pw1, $pw2)
            .map { [weak self] pw1, pw2 in
                self?.getPasswordErrorMessage(pw1: pw1, pw2: pw2)
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$errorMessage)
    }
    
    private func validatePasswords(pw1: String, pw2: String) -> Bool {
        guard !pw1.isEmpty && !pw2.isEmpty else { return false }
        guard pw1 == pw2 else { return false }
        return isValidPassword(pw1)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        // 최소 8자 이상, 영문자와 숫자 포함
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d@$!%*?&]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    private func getPasswordErrorMessage(pw1: String, pw2: String) -> String? {
        guard !pw1.isEmpty || !pw2.isEmpty else { return nil }
        
        if !pw1.isEmpty && !isValidPassword(pw1) {
            return "비밀번호는 최소 8자 이상, 영문자와 숫자를 포함해야 합니다"
        }
        
        if !pw1.isEmpty && !pw2.isEmpty && pw1 != pw2 {
            return "비밀번호가 일치하지 않습니다"
        }
        
        return nil
    }
}
