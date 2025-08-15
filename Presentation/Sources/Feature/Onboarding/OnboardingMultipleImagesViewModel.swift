//
//  OnboardingMultipleImagesViewModel.swift
//  Presentation
//
//  Created by 신동규 on 8/15/25.
//

import Domain
import Factory
import Combine
import SwiftUI

final class OnboardingMultipleImagesViewModel: ObservableObject {
    
    @Published var images: [UIImage] = []
    
    
    init() {
        
    }
}
