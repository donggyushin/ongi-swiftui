//
//  ProfileRepository.swift
//  Domain
//
//  Created by 신동규 on 8/14/25.
//

public protocol PProfileRepository {
    func getMe(accessToken: String) async throws -> ProfileEntitiy
}
