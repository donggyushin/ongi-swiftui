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
    
    public func profileImageUpload(imageData: Data) async throws -> ProfileEntitiy {
        try await profileRemoteDataSource.profileImageUpload(imageData: imageData)
    }
    
    public func uploadImage(imageData: Data) async throws -> ProfileEntitiy {
        try await profileRemoteDataSource.uploadImage(imageData: imageData)
    }
    
    public func updateGender(gender: GenderEntity) async throws -> ProfileEntitiy {
        try await profileRemoteDataSource.updateGender(gender: gender)
    }
    
    public func updatePhysicalInfo(height: CGFloat, weight: CGFloat) async throws -> ProfileEntitiy {
        try await profileRemoteDataSource.updatePhysicalInfo(height: height, weight: weight)
    }
    
    public func deleteImage(publicId: String) async throws -> ProfileEntitiy {
        try await profileRemoteDataSource.deleteImage(publicId: publicId)
    }
    
    public func updateNickname(nickname: String) async throws -> ProfileEntitiy {
        try await profileRemoteDataSource.updateNickname(nickname: nickname)
    }
    
    public func updateMBTI(mbti: MBTIEntity) async throws -> ProfileEntitiy {
        try await profileRemoteDataSource.updateMBTI(mbti: mbti)
    }
    
    public func updateIntroduce(introduce: String) async throws -> ProfileEntitiy {
        try await profileRemoteDataSource.updateIntroduce(introduce: introduce)
    }
}
