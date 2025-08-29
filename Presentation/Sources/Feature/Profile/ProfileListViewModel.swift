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
    @Published var hasUnreadNotifications = false
    
    @Injected(\.contentViewModel) private var contentViewModel
    @Injected(\.connectionUseCase) private var connectionUseCase
    @Injected(\.notificationsUseCase) private var notificationsUseCase
    
    public init() {
        bind()
    }
    
    @MainActor
    func onAppear() async throws {
        loading = true
        defer { loading = false }
        
        async let connectionResult = connectionUseCase.getConnection()
        async let profilesLikeMe = connectionUseCase.getProfilesLikeMe()
        async let unreadNotificationsCount = notificationsUseCase.unreadCount()
        
        let result: ConnectionEntity = try await connectionResult
        let result2: [ProfileEntitiy] = try await profilesLikeMe
        let result3 = try await unreadNotificationsCount
        
        profiles = result.profiles
        newProfilesIds = result.newProfileIds
        profileIDsLikeMe = result2.map { $0.id }
        hasUnreadNotifications = result3 > 0
    }
    
    private func bind() {
        contentViewModel
            .$me
            .map { $0 }
            .receive(on: DispatchQueue.main)
            .assign(to: &$me)
    }
}
