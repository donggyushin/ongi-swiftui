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
    
    @Injected(\.profileUseCase) private var profileUseCase
    @Injected(\.contentViewModel) private var contentViewModel
    
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
    func fetchInitialInfo() async throws {
        loading = true
        defer { loading = false }
        let me = try await profileUseCase.getMe()
        selectedGender = me.gender
        height = me.height == nil ? "" : "\(me.height!)"
        weight = me.weight == nil ? "" : "\(me.weight!)"
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
        
        _ = try await profileUseCase.updateGender(gender: gender)
        let updatedProfile = try await profileUseCase.updatePhysicalInfo(height: heightValue, weight: weightValue)
        contentViewModel.me = updatedProfile
    }
}
