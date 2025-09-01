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
    
    @Published var loading = false 
    
    @Published var email = ""
    @Published var errorMessage: String?
    @Published var isNextButtonEnabled: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    @Injected(\.authUseCase) private var authUseCase
    
    init() {
        bind()
    }
    
    @MainActor
    func searchAccount() async throws -> ProfileEntitiy {
        guard loading == false else { throw AppError.dataError(.duplicateEntry) }
        loading = true
        defer { loading = false }
        return try await authUseCase.searchAccount(email: email)
    }
    
    private func bind() {
        $email
            .map { [weak self] email in
                self?.validateEmail(email) ?? false
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$isNextButtonEnabled)
        
        $email
            .map { [weak self] email in
                self?.getEmailErrorMessage(email)
            }
            .receive(on: DispatchQueue.main)
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
