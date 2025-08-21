//
//  ProfileListLikeMeViewModel.swift
//  Presentation
//
//  Created by 신동규 on 8/21/25.
//

import SwiftUI
import Domain
import Combine
import Factory

final class ProfileListLikeMeViewModel: ObservableObject {
    @Injected(\.connectionUseCase) private var connectionUseCase
    
    @Published var loading = false
    @Published var profiles: [ProfileEntitiy] = []
    
    init() {
        
    }
    
    @MainActor
    func fetchProfiles() async throws {
        loading = true
        defer { loading = false }
        profiles = try await connectionUseCase.getProfilesLikeMe()
    }
}
