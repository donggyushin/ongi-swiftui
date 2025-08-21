//
//  MockConnectionRepository.swift
//  DataSource
//
//  Created by 신동규 on 8/17/25.
//

import Domain
import Foundation

final class MockConnectionRepository: PConnectionRepository {
    
    // MARK: - Shared Data Store
    private let dataStore = MockDataStore.shared
    
    
    // MARK: - Helper Methods
    private func simulateNetworkDelay() async throws {
        try await Task.sleep(for: .milliseconds(Int.random(in: 500...2000)))
    }
    
    private func randomError() -> AppError {
        let errors = [
            AppError.custom("네트워크 연결이 불안정합니다.", code: 1001),
            AppError.custom("서버에서 일시적인 오류가 발생했습니다.", code: 1002),
            AppError.custom("요청 처리 중 오류가 발생했습니다.", code: 1003)
        ]
        return errors.randomElement()!
    }
    
    // MARK: - Repository Implementation
    func getConnection() async throws -> ConnectionEntity {
        try await simulateNetworkDelay()
        
        // Simulate occasional errors (5% chance)
        if Int.random(in: 1...100) <= 5 {
            throw randomError()
        }
        
        // Get available profiles from data store
        let availableProfiles = dataStore.getAvailableProfiles(for: "me", excludeViewed: true)
        
        // Get random subset of profiles (2-5 profiles)
        let profileCount = min(Int.random(in: 2...5), availableProfiles.count)
        let selectedProfiles = Array(availableProfiles.shuffled().prefix(profileCount))
        
        // Identify new profiles (created within last 3 days)
        let newProfileIds = dataStore.getNewProfiles(for: "me").map { $0.id }
        
        return .init(
            profiles: selectedProfiles,
            newProfileIds: newProfileIds,
            profileIDsILike: dataStore.getViewHistory(for: "me"),
            profileIDsLikeMe: dataStore.getProfilesWhoLike("me").map { $0.id },
            count: selectedProfiles.count,
            limit: 100
        )
    }
    
    func markViewed(profileId: String) async throws -> [ConnectedProfileEntity] {
        try await simulateNetworkDelay()
        
        // Add to viewed profiles in data store
        dataStore.addToViewHistory(userId: "me", viewedProfileId: profileId)
        
        // Return connected profiles (mutual connections)
        let connections = dataStore.getConnections(for: "me")
        
        return connections.map { profile in
            ConnectedProfileEntity(
                profileId: profile.id,
                addedAt: Date().addingTimeInterval(-TimeInterval.random(in: 0...7*24*60*60)),
                isNew: profile.isNew
            )
        }
    }
    
    func like(profileId: String) async throws {
        try await simulateNetworkDelay()
        
        // Simulate occasional errors (3% chance)
        if Int.random(in: 1...100) <= 3 {
            throw AppError.custom("좋아요 처리 중 오류가 발생했습니다.", code: 1004)
        }
        
        // Add like to data store
        dataStore.addLike(from: "me", to: profileId)
    }
    
    func cancelLike(profileId: String) async throws {
        try await simulateNetworkDelay()
        
        // Simulate occasional errors (2% chance)
        if Int.random(in: 1...100) <= 2 {
            throw AppError.custom("좋아요 취소 중 오류가 발생했습니다.", code: 1005)
        }
        
        // Remove like from data store
        dataStore.removeLike(from: "me", to: profileId)
    }
    
    func getProfilesLikeMe() async throws -> [ProfileEntitiy] {
        try await simulateNetworkDelay()
        
        // Simulate occasional errors (5% chance)
        if Int.random(in: 1...100) <= 5 {
            throw randomError()
        }
        
        // Get profiles who like me from data store
        return dataStore.getProfilesWhoLike("me")
    }
    
    // MARK: - Test Helper Methods
    func reset() {
        dataStore.resetUserData(userId: "me")
    }
    
    func simulateMoreLikes() {
        // Add more profiles to those who like me via data store
        let allProfiles = dataStore.getAllProfiles()
        let additionalLikes = Array(allProfiles.shuffled().prefix(3))
        
        for profile in additionalLikes {
            dataStore.addLike(from: profile.id, to: "me")
        }
    }
    
    func simulateEmptyState() {
        dataStore.applyScenario(.empty)
    }
    
    func getLikeStatistics() -> (liked: Int, likedMe: Int, mutual: Int) {
        let stats = dataStore.getStatistics(for: "me")
        return (
            liked: stats.likesGiven,
            likedMe: stats.likesReceived,
            mutual: stats.mutualLikes
        )
    }
}
