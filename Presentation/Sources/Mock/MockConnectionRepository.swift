//
//  MockConnectionRepository.swift
//  DataSource
//
//  Created by 신동규 on 8/17/25.
//

import Domain
import Foundation

final class MockConnectionRepository: PConnectionRepository {
    func getConnection() async throws -> ConnectionEntity {
        let profileRepository = MockProfileRepository()
        
        try await Task.sleep(for: .seconds(2))
        
        return .init(
            profiles: [profileRepository.profile1, profileRepository.profile2],
//            profiles: [],
            newProfileIds: [profileRepository.profile2.id],
            profileIDsILike: ["asd", "asdsad"],
            profileIDsLikeMe: ["asd", "asdsad"],
            count: 2,
            limit: 100
        )
    }
    
    func markViewed(profileId: String) async throws -> [ConnectedProfileEntity] {
        let profileRepository = MockProfileRepository()
        
        try await Task.sleep(for: .seconds(2))
        
        return [
            .init(profileId: profileRepository.profile1.id, addedAt: Date(), isNew: false),
            .init(profileId: profileRepository.profile2.id, addedAt: Date(), isNew: false)
        ]
    }
    
    func like(profileId: String) async throws {
        try await Task.sleep(for: .seconds(0.7))
    }
    
    func cancelLike(profileId: String) async throws {
        try await Task.sleep(for: .seconds(0.7))
    }
    
    func getProfilesLikeMe() async throws -> [ProfileEntitiy] {
        let profileRepository = MockProfileRepository()
        try await Task.sleep(for: .seconds(0.7))
        return [
            profileRepository.profile1,
            profileRepository.profile2,
            profileRepository.profile3
        ]
    }
}
