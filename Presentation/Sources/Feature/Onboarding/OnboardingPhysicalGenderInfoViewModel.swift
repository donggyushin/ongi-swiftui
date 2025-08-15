//
//  OnboardingPhysicalGenderInfoViewModel.swift
//  Presentation
//
//  Created by 신동규 on 8/16/25.
//

import Domain
import Factory
import Combine
import SwiftUI

final class OnboardingPhysicalGenderInfoViewModel: ObservableObject {
    
    @Published var selectedGender: GenderEntity?
    @Published var height: String = ""
    @Published var weight: String = ""
    @Published var loading: Bool = false
    
    var isFormValid: Bool {
        return selectedGender != nil && 
               !height.isEmpty && 
               !weight.isEmpty &&
               heightValue != nil &&
               weightValue != nil
    }
    
    var heightValue: CGFloat? {
        guard let value = Double(height), value > 0 else { return nil }
        return CGFloat(value)
    }
    
    var weightValue: CGFloat? {
        guard let value = Double(weight), value > 0 else { return nil }
        return CGFloat(value)
    }
    
    @MainActor
    func savePhysicalInfo() async throws {
        loading = true
        defer { loading = false }
        
        guard let gender = selectedGender,
              let heightValue = heightValue,
              let weightValue = weightValue else {
            throw AppError.custom("필수 정보를 입력해주세요", code: 400)
        }
        
        // TODO: Implement save logic
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}
