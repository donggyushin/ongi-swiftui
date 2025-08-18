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

public final class ProfileDetailViewModel: ObservableObject {
    
    public let profileId: String
    
    @Published var profile: ProfileEntitiy?
    
    let profileUseCase = Container.shared.profileUseCase()
    
    public init(profileId: String) {
        self.profileId = profileId
    }
    
    @MainActor
    func fetchProfile() async throws {
        profile = try await profileUseCase.search(profileId: profileId)
    }
    
}
