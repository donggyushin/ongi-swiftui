//
//  OnboardingProfileImageViewModel.swift
//  Presentation
//
//  Created by 신동규 on 8/15/25.
//

import Domain
import Combine
import SwiftUI

public final class OnboardingProfileImageViewModel: ObservableObject {
    
    @Published var profileImage: UIImage?
    @Published var showImagePicker = false
    @Published var showActionSheet = false 
    
    public init() {
        
    }
    
    func selectImage() {
        showImagePicker = true
    }
    
    func uploadPhoto() async throws {
        
    }
}
