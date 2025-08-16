//
//  ProfileRepository.swift
//  Domain
//
//  Created by 신동규 on 8/14/25.
//

import Foundation

public protocol PProfileRepository {
    func getMe(accessToken: String) async throws -> ProfileEntitiy
    func profileImageUpload(imageData: Data) async throws -> ProfileEntitiy
    func uploadImage(imageData: Data) async throws -> ProfileEntitiy
    func updateGender(gender: GenderEntity) async throws -> ProfileEntitiy
    func updatePhysicalInfo(height: CGFloat, weight: CGFloat) async throws -> ProfileEntitiy
    func deleteImage(publicId: String) async throws -> ProfileEntitiy
    func updateNickname(nickname: String) async throws -> ProfileEntitiy
    func updateMBTI(mbti: MBTIEntity) async throws -> ProfileEntitiy
    func updateIntroduce(introduce: String) async throws -> ProfileEntitiy
}
