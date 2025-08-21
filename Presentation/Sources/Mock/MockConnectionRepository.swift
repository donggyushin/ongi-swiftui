//
//  MockConnectionRepository.swift
//  DataSource
//
//  Created by 신동규 on 8/17/25.
//

import Domain
import Foundation

final class MockConnectionRepository: PConnectionRepository {
    
    // MARK: - Shared Profile Repository
    private let profileRepository = MockProfileRepository()
    
    // MARK: - Mock State Management
    private var likedProfiles: Set<String> = ["user_002", "user_006", "user_008"]
    private var profilesWhoLikeMe: Set<String> = ["user_001", "user_003", "user_005", "user_007", "user_009"]
    private var viewedProfiles: Set<String> = []
    
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
        
        let allProfiles = profileRepository.getAllProfiles()
        
        // Filter out viewed profiles for variety
        let availableProfiles = allProfiles.filter { profile in
            !viewedProfiles.contains(profile.id)
        }
        
        // Get random subset of profiles (2-5 profiles)
        let profileCount = min(Int.random(in: 2...5), availableProfiles.count)
        let selectedProfiles = Array(availableProfiles.shuffled().prefix(profileCount))
        
        // Update liked status based on our state
        let profilesWithLikeStatus = selectedProfiles.map { profile in
            ProfileEntitiy(
                id: profile.id,
                nickname: profile.nickname,
                email: profile.email,
                profileImage: profile.profileImage,
                images: profile.images,
                mbti: profile.mbti,
                qnas: profile.qnas,
                gender: profile.gender,
                height: profile.height,
                weight: profile.weight,
                bodyType: profile.bodyType,
                introduction: profile.introduction,
                isNew: profile.isNew,
                isLikedByMe: likedProfiles.contains(profile.id),
                createdAt: profile.createdAt,
                updatedAt: profile.updatedAt
            )
        }
        
        // Identify new profiles (created within last 3 days)
        let threeDaysAgo = Date().addingTimeInterval(-3 * 24 * 60 * 60)
        let newProfileIds = profilesWithLikeStatus
            .filter { $0.createdAt > threeDaysAgo }
            .map { $0.id }
        
        return .init(
            profiles: profilesWithLikeStatus,
            newProfileIds: newProfileIds,
            profileIDsILike: Array(likedProfiles),
            profileIDsLikeMe: Array(profilesWhoLikeMe),
            count: profilesWithLikeStatus.count,
            limit: 100
        )
    }
    
    func markViewed(profileId: String) async throws -> [ConnectedProfileEntity] {
        try await simulateNetworkDelay()
        
        // Add to viewed profiles
        viewedProfiles.insert(profileId)
        
        // Return connected profiles (profiles who mutually liked)
        let mutualLikes = likedProfiles.intersection(profilesWhoLikeMe)
        
        return mutualLikes.map { profileId in
            ConnectedProfileEntity(
                profileId: profileId,
                addedAt: Date().addingTimeInterval(-TimeInterval.random(in: 0...7*24*60*60)), // Random date within last week
                isNew: Bool.random()
            )
        }
    }
    
    func like(profileId: String) async throws {
        try await simulateNetworkDelay()
        
        // Simulate occasional errors (3% chance)
        if Int.random(in: 1...100) <= 3 {
            throw AppError.custom("좋아요 처리 중 오류가 발생했습니다.", code: 1004)
        }
        
        // Add to liked profiles
        likedProfiles.insert(profileId)
        
        // Simulate that sometimes the other person also likes back (30% chance)
        if Int.random(in: 1...100) <= 30 {
            profilesWhoLikeMe.insert(profileId)
        }
    }
    
    func cancelLike(profileId: String) async throws {
        try await simulateNetworkDelay()
        
        // Simulate occasional errors (2% chance)
        if Int.random(in: 1...100) <= 2 {
            throw AppError.custom("좋아요 취소 중 오류가 발생했습니다.", code: 1005)
        }
        
        // Remove from liked profiles
        likedProfiles.remove(profileId)
    }
    
    func getProfilesLikeMe() async throws -> [ProfileEntitiy] {
        try await simulateNetworkDelay()
        
        // Simulate occasional errors (5% chance)
        if Int.random(in: 1...100) <= 5 {
            throw randomError()
        }
        
        let allProfiles = profileRepository.getAllProfiles()
        
        // Filter profiles who like me
        let profilesLikingMe = allProfiles.filter { profile in
            profilesWhoLikeMe.contains(profile.id)
        }
        
        // Update with correct like status
        return profilesLikingMe.map { profile in
            ProfileEntitiy(
                id: profile.id,
                nickname: profile.nickname,
                email: profile.email,
                profileImage: profile.profileImage,
                images: profile.images,
                mbti: profile.mbti,
                qnas: profile.qnas,
                gender: profile.gender,
                height: profile.height,
                weight: profile.weight,
                bodyType: profile.bodyType,
                introduction: profile.introduction,
                isNew: profile.isNew,
                isLikedByMe: likedProfiles.contains(profile.id),
                createdAt: profile.createdAt,
                updatedAt: profile.updatedAt
            )
        }.sorted { $0.createdAt > $1.createdAt } // Sort by most recent first
    }
    
    // MARK: - Test Helper Methods
    func reset() {
        likedProfiles.removeAll()
        profilesWhoLikeMe = ["user_001", "user_003", "user_005", "user_007", "user_009"]
        viewedProfiles.removeAll()
    }
    
    func simulateMoreLikes() {
        // Add more profiles to those who like me
        let allProfileIds = profileRepository.getAllProfiles().map { $0.id }
        let additionalLikes = Set(allProfileIds.shuffled().prefix(3))
        profilesWhoLikeMe.formUnion(additionalLikes)
    }
    
    func simulateEmptyState() {
        profilesWhoLikeMe.removeAll()
        likedProfiles.removeAll()
    }
    
    func getLikeStatistics() -> (liked: Int, likedMe: Int, mutual: Int) {
        let mutual = likedProfiles.intersection(profilesWhoLikeMe).count
        return (
            liked: likedProfiles.count,
            likedMe: profilesWhoLikeMe.count,
            mutual: mutual
        )
    }
}
