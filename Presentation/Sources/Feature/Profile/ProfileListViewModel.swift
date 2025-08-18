//
//  ProfileListViewModel.swift
//  DataSource
//
//  Created by 신동규 on 8/14/25.
//

import Domain
import Combine
import Factory

public final class ProfileListViewModel: ObservableObject {
    
    @Published var profiles: [ProfileEntitiy] = []
    @Published var newProfilesIds: [String] = []
    @Published var loading = false
    
    let connectionUseCase = Container.shared.connectionUseCase()
    
    public init() {
        
    }
    
    @MainActor
    func fetchConnectionList() async throws {
        loading = true
        defer { loading = false }
        let result: ConnectionEntity = try await connectionUseCase.getConnection()
        
        profiles = result.profiles
        newProfilesIds = result.newProfileIds
    }
}
