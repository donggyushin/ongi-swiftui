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
    @Published var loading = false
    
    let connectionUseCase = Container.shared.connectionUseCase()
    let profileUseCase = Container.shared.profileUseCase()
    
    public init() { }
    
    @MainActor
    func onAppear() async throws {
        loading = true
        defer { loading = false }
        
        async let connectionResult = connectionUseCase.getConnection()
        async let meProfile = profileUseCase.getMe()
        
        let result: ConnectionEntity = try await connectionResult
        profiles = result.profiles
        newProfilesIds = result.newProfileIds
        
        me = try await meProfile
    }
}
