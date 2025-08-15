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
}
