//
//  ProfileRepository.swift
//  DataSource
//
//  Created by 신동규 on 8/14/25.
//

import Domain

public final class ProfileRepository: PProfileRepository {
    
    public static let shared = ProfileRepository()
    
    let profileRemoteDataSource = ProfileRemoteDataSource()
    
    private init() {
        
    }
    
    public func getMe(accessToken: String) async throws -> ProfileEntitiy {
        try await profileRemoteDataSource.getMe(accessToken: accessToken)
    }
}
