//
//  ProfileDetailViewModel.swift
//  Presentation
//
//  Created by 신동규 on 8/18/25.
//

import Factory
import Domain
import SwiftUI
import Combine

final class ProfileDetailViewModel: ObservableObject {
    
    let profileId: String
    
    init(profileId: String) {
        self.profileId = profileId
    }
    
}
