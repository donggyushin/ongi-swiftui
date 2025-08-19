//
//  PConnectionRepository.swift
//  Domain
//
//  Created by 신동규 on 8/17/25.
//

public protocol PConnectionRepository {
    func getConnection() async throws -> ConnectionEntity
    func markViewed(profileId: String) async throws -> [IsNewProfileEntitiy]
}
