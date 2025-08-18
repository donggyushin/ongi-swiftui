//
//  MockConnectionRepository.swift
//  DataSource
//
//  Created by 신동규 on 8/17/25.
//

import Domain

final class MockConnectionRepository: PConnectionRepository {
    func getConnection() async throws -> ConnectionEntity {
        let profileRepository = MockProfileRepository()
        
        try await Task.sleep(for: .seconds(2))
        
        return .init(
            profiles: [profileRepository.profile1, profileRepository.profile2],
//            profiles: [],
            newProfileIds: [profileRepository.profile2.id],
            count: 2,
            limit: 100
        )
    }
}
