//
//  MockDataStore.swift
//  Presentation
//
//  Created by 신동규 on 8/21/25.
//

import Foundation
import Domain
import Combine

public class MockDataStore: ObservableObject {
    
    public static let shared = MockDataStore()
    
    @Published public private(set) var profiles: [String: ProfileEntitiy] = [:]
    @Published public private(set) var connections: [String: Set<String>] = [:] // userId -> Set of connected userIds
    @Published public private(set) var likes: [String: Set<String>] = [:] // userId -> Set of liked userIds
    @Published public private(set) var viewHistory: [String: Set<String>] = [:] // userId -> Set of viewed userIds
    
    private let dataGenerator = MockDataGenerator.shared
    private let scenarioManager = MockScenarioManager.shared
    
    private init() {
        initializeWithDefaultData()
    }
    
    // MARK: - Initialization
    private func initializeWithDefaultData() {
        // Generate initial profile data
        let initialProfiles = dataGenerator.generateProfiles(count: 15)
        
        for profile in initialProfiles {
            profiles[profile.id] = profile
        }
        
        // Initialize mock user state
        initializeMockUserState()
    }
    
    private func initializeMockUserState() {
        let userId = "me"
        let allProfileIds = Array(profiles.keys)
        
        // Initialize likes (who I liked)
        let myLikes = Set(allProfileIds.shuffled().prefix(Int.random(in: 2...5)))
        likes[userId] = myLikes
        
        // Initialize who likes me
        let whoLikesMe = Set(allProfileIds.shuffled().prefix(Int.random(in: 3...8)))
        for profileId in whoLikesMe {
            if likes[profileId] == nil {
                likes[profileId] = Set()
            }
            likes[profileId]?.insert(userId)
        }
        
        // Initialize view history
        viewHistory[userId] = Set(allProfileIds.shuffled().prefix(Int.random(in: 5...10)))
        
        // Initialize connections (mutual likes)
        let mutualLikes = myLikes.intersection(whoLikesMe)
        connections[userId] = mutualLikes
        
        for profileId in mutualLikes {
            if connections[profileId] == nil {
                connections[profileId] = Set()
            }
            connections[profileId]?.insert(userId)
        }
    }
    
    // MARK: - Profile Management
    public func getProfile(id: String) -> ProfileEntitiy? {
        return profiles[id]
    }
    
    public func getAllProfiles() -> [ProfileEntitiy] {
        return Array(profiles.values)
    }
    
    public func getProfiles(ids: [String]) -> [ProfileEntitiy] {
        return ids.compactMap { profiles[$0] }
    }
    
    public func addProfile(_ profile: ProfileEntitiy) {
        profiles[profile.id] = profile
    }
    
    public func updateProfile(_ profile: ProfileEntitiy) {
        profiles[profile.id] = profile
    }
    
    public func removeProfile(id: String) {
        profiles.removeValue(forKey: id)
        
        // Clean up related data
        connections.removeValue(forKey: id)
        likes.removeValue(forKey: id)
        viewHistory.removeValue(forKey: id)
        
        // Remove from other users' data
        for userId in connections.keys {
            connections[userId]?.remove(id)
        }
        
        for userId in likes.keys {
            likes[userId]?.remove(id)
        }
        
        for userId in viewHistory.keys {
            viewHistory[userId]?.remove(id)
        }
    }
    
    // MARK: - Connection Management
    public func getConnections(for userId: String) -> [ProfileEntitiy] {
        guard let connectionIds = connections[userId] else { return [] }
        return getProfiles(ids: Array(connectionIds))
    }
    
    public func addConnection(from userId: String, to targetId: String) {
        if connections[userId] == nil {
            connections[userId] = Set()
        }
        connections[userId]?.insert(targetId)
        
        if connections[targetId] == nil {
            connections[targetId] = Set()
        }
        connections[targetId]?.insert(userId)
    }
    
    public func removeConnection(from userId: String, to targetId: String) {
        connections[userId]?.remove(targetId)
        connections[targetId]?.remove(userId)
    }
    
    // MARK: - Like Management
    public func getLikedProfiles(by userId: String) -> [ProfileEntitiy] {
        guard let likedIds = likes[userId] else { return [] }
        return getProfiles(ids: Array(likedIds)).map { profile in
            updateProfileLikeStatus(profile, likedBy: userId)
        }
    }
    
    public func getProfilesWhoLike(_ userId: String) -> [ProfileEntitiy] {
        var profilesWhoLike: [ProfileEntitiy] = []
        
        for (profileId, likedUsers) in likes {
            if likedUsers.contains(userId), let profile = profiles[profileId] {
                let updatedProfile = updateProfileLikeStatus(profile, likedBy: userId)
                profilesWhoLike.append(updatedProfile)
            }
        }
        
        return profilesWhoLike.sorted { $0.createdAt > $1.createdAt }
    }
    
    public func addLike(from userId: String, to targetId: String) {
        if likes[userId] == nil {
            likes[userId] = Set()
        }
        likes[userId]?.insert(targetId)
        
        // Check for mutual like and create connection
        if let targetLikes = likes[targetId], targetLikes.contains(userId) {
            addConnection(from: userId, to: targetId)
        }
    }
    
    public func removeLike(from userId: String, to targetId: String) {
        likes[userId]?.remove(targetId)
        
        // Remove connection if it exists
        removeConnection(from: userId, to: targetId)
    }
    
    public func isLiked(profileId: String, by userId: String) -> Bool {
        return likes[userId]?.contains(profileId) ?? false
    }
    
    public func isLiking(userId: String, profile profileId: String) -> Bool {
        return likes[profileId]?.contains(userId) ?? false
    }
    
    // MARK: - View History Management
    public func addToViewHistory(userId: String, viewedProfileId: String) {
        if viewHistory[userId] == nil {
            viewHistory[userId] = Set()
        }
        viewHistory[userId]?.insert(viewedProfileId)
    }
    
    public func getViewHistory(for userId: String) -> [String] {
        return Array(viewHistory[userId] ?? [])
    }
    
    public func hasViewed(userId: String, profileId: String) -> Bool {
        return viewHistory[userId]?.contains(profileId) ?? false
    }
    
    // MARK: - Query Methods
    public func getAvailableProfiles(for userId: String, excludeViewed: Bool = true) -> [ProfileEntitiy] {
        var availableProfiles = Array(profiles.values)
        
        // Exclude self
        availableProfiles = availableProfiles.filter { $0.id != userId }
        
        // Exclude viewed profiles if requested
        if excludeViewed {
            let viewed = viewHistory[userId] ?? Set()
            availableProfiles = availableProfiles.filter { !viewed.contains($0.id) }
        }
        
        // Update like status
        return availableProfiles.map { profile in
            updateProfileLikeStatus(profile, likedBy: userId)
        }
    }
    
    public func getNewProfiles(for userId: String, withinDays days: Int = 3) -> [ProfileEntitiy] {
        let cutoffDate = Date().addingTimeInterval(-TimeInterval(days * 24 * 60 * 60))
        
        return getAvailableProfiles(for: userId)
            .filter { $0.createdAt > cutoffDate }
            .sorted { $0.createdAt > $1.createdAt }
    }
    
    public func getMutualLikes(for userId: String) -> [ProfileEntitiy] {
        guard let myLikes = likes[userId] else { return [] }
        
        var mutualLikes: [ProfileEntitiy] = []
        
        for profileId in myLikes {
            if let theirLikes = likes[profileId], theirLikes.contains(userId),
               let profile = profiles[profileId] {
                let updatedProfile = updateProfileLikeStatus(profile, likedBy: userId)
                mutualLikes.append(updatedProfile)
            }
        }
        
        return mutualLikes
    }
    
    // MARK: - Statistics
    public func getStatistics(for userId: String) -> MockDataStatistics {
        let myLikes = likes[userId]?.count ?? 0
        let likesReceived = likes.values.reduce(0) { count, likedUsers in
            count + (likedUsers.contains(userId) ? 1 : 0)
        }
        let mutualLikes = getMutualLikes(for: userId).count
        let viewedCount = viewHistory[userId]?.count ?? 0
        let totalProfiles = profiles.count
        
        return MockDataStatistics(
            totalProfiles: totalProfiles,
            likesGiven: myLikes,
            likesReceived: likesReceived,
            mutualLikes: mutualLikes,
            profilesViewed: viewedCount,
            connectionsCount: connections[userId]?.count ?? 0
        )
    }
    
    // MARK: - Helper Methods
    private func updateProfileLikeStatus(_ profile: ProfileEntitiy, likedBy userId: String) -> ProfileEntitiy {
        let isLikedByMe = isLiked(profileId: profile.id, by: userId)
        
        return ProfileEntitiy(
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
            isLikedByMe: isLikedByMe,
            createdAt: profile.createdAt,
            updatedAt: profile.updatedAt
        )
    }
    
    // MARK: - Scenario Management
    public func applyScenario(_ scenario: MockScenario) {
        switch scenario {
        case .empty:
            applyEmptyScenario()
        case .popular:
            applyPopularScenario()
        case .newUser:
            applyNewUserScenario()
        default:
            break
        }
    }
    
    private func applyEmptyScenario() {
        likes["me"] = Set()
        
        // Remove all likes to me
        for userId in likes.keys {
            likes[userId]?.remove("me")
        }
        
        connections["me"] = Set()
    }
    
    private func applyPopularScenario() {
        let allProfileIds = Array(profiles.keys)
        let manyLikes = Set(allProfileIds.shuffled().prefix(Int.random(in: 10...15)))
        
        // Add many likes to me
        for profileId in manyLikes {
            if likes[profileId] == nil {
                likes[profileId] = Set()
            }
            likes[profileId]?.insert("me")
        }
    }
    
    private func applyNewUserScenario() {
        // Simulate new user with minimal data
        likes["me"] = Set()
        connections["me"] = Set()
        viewHistory["me"] = Set()
        
        // Only a few people like the new user
        let allProfileIds = Array(profiles.keys)
        let fewLikes = Set(allProfileIds.shuffled().prefix(Int.random(in: 0...2)))
        
        for profileId in fewLikes {
            if likes[profileId] == nil {
                likes[profileId] = Set()
            }
            likes[profileId]?.insert("me")
        }
    }
    
    // MARK: - Reset Methods
    public func reset() {
        profiles.removeAll()
        connections.removeAll()
        likes.removeAll()
        viewHistory.removeAll()
        
        initializeWithDefaultData()
    }
    
    public func resetUserData(userId: String = "me") {
        likes[userId] = Set()
        connections[userId] = Set()
        viewHistory[userId] = Set()
        
        // Remove from other users' data
        for otherUserId in likes.keys {
            likes[otherUserId]?.remove(userId)
        }
        
        for otherUserId in connections.keys {
            connections[otherUserId]?.remove(userId)
        }
    }
}

// MARK: - Supporting Types
public struct MockDataStatistics {
    public let totalProfiles: Int
    public let likesGiven: Int
    public let likesReceived: Int
    public let mutualLikes: Int
    public let profilesViewed: Int
    public let connectionsCount: Int
    
    public var summary: String {
        return """
        총 프로필: \(totalProfiles)개
        보낸 좋아요: \(likesGiven)개
        받은 좋아요: \(likesReceived)개
        서로 좋아요: \(mutualLikes)개
        조회한 프로필: \(profilesViewed)개
        연결된 사용자: \(connectionsCount)개
        """
    }
}

// MARK: - Debug Extensions
#if DEBUG
extension MockDataStore {
    
    public func debugPrint() {
        print("=== Mock Data Store Debug ===")
        print("Profiles: \(profiles.count)")
        print("Connections: \(connections)")
        print("Likes: \(likes)")
        print("View History: \(viewHistory)")
        print("===========================")
    }
    
    public func exportData() -> [String: Any] {
        return [
            "profiles": profiles.mapValues { $0.nickname },
            "connections": connections,
            "likes": likes,
            "viewHistory": viewHistory
        ]
    }
}
#endif