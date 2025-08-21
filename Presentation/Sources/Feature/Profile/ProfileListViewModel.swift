//
//  ProfileListViewModel.swift
//  DataSource
//
//  Created by 신동규 on 8/14/25.
//

import Domain
import Factory
import SwiftUI

public final class ProfileListViewModel: ObservableObject {
    
    @Published var me: ProfileEntitiy?
    @Published var profiles: [ProfileEntitiy] = []
    @Published var newProfilesIds: [String] = []
    @Published var profileIDsLikeMe: [String] = []
    @Published var loading = false
    
    @Injected(\.connectionUseCase) private var connectionUseCase
    
    public init() {
        bind()
    }
    
    @MainActor
    func onAppear() async throws {
        loading = true
        defer { loading = false }
        
        async let connectionResult = connectionUseCase.getConnection()
        async let profilesLikeMe = connectionUseCase.getProfilesLikeMe()
        
        let result: ConnectionEntity = try await connectionResult
        let result2: [ProfileEntitiy] = try await profilesLikeMe
        profiles = result.profiles
        newProfilesIds = result.newProfileIds
        profileIDsLikeMe = result2.map { $0.id }
    }
    
    @Injected(\.contentViewModel) private var contentViewModel
    
    private func bind() {
        contentViewModel
            .$me
            .map { $0 }
            .receive(on: DispatchQueue.main)
            .assign(to: &$me)
    }
}
