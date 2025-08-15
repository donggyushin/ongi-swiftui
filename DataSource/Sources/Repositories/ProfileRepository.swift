//
//  ProfileRepository.swift
//  DataSource
//
//  Created by 신동규 on 8/14/25.
//

import Domain
import Foundation

public final class ProfileRepository: PProfileRepository {
    
    public static let shared = ProfileRepository()
    
    let profileRemoteDataSource = ProfileRemoteDataSource()
    
    private init() {
        
    }
    
    public func getMe(accessToken: String) async throws -> ProfileEntitiy {
        try await profileRemoteDataSource.getMe(accessToken: accessToken)
    }
    
    public func profileImageUpload(imageData: Data) async throws -> Domain.ProfileEntitiy {
        try await profileRemoteDataSource.profileImageUpload(imageData: imageData)
    }
}
