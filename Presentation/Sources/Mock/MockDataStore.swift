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
        }\n    }\n    \n    public func getProfilesWhoLike(_ userId: String) -> [ProfileEntitiy] {\n        var profilesWhoLike: [ProfileEntitiy] = []\n        \n        for (profileId, likedUsers) in likes {\n            if likedUsers.contains(userId), let profile = profiles[profileId] {\n                let updatedProfile = updateProfileLikeStatus(profile, likedBy: userId)\n                profilesWhoLike.append(updatedProfile)\n            }\n        }\n        \n        return profilesWhoLike.sorted { $0.createdAt > $1.createdAt }\n    }\n    \n    public func addLike(from userId: String, to targetId: String) {\n        if likes[userId] == nil {\n            likes[userId] = Set()\n        }\n        likes[userId]?.insert(targetId)\n        \n        // Check for mutual like and create connection\n        if let targetLikes = likes[targetId], targetLikes.contains(userId) {\n            addConnection(from: userId, to: targetId)\n        }\n    }\n    \n    public func removeLike(from userId: String, to targetId: String) {\n        likes[userId]?.remove(targetId)\n        \n        // Remove connection if it exists\n        removeConnection(from: userId, to: targetId)\n    }\n    \n    public func isLiked(profileId: String, by userId: String) -> Bool {\n        return likes[userId]?.contains(profileId) ?? false\n    }\n    \n    public func isLiking(userId: String, profile profileId: String) -> Bool {\n        return likes[profileId]?.contains(userId) ?? false\n    }\n    \n    // MARK: - View History Management\n    public func addToViewHistory(userId: String, viewedProfileId: String) {\n        if viewHistory[userId] == nil {\n            viewHistory[userId] = Set()\n        }\n        viewHistory[userId]?.insert(viewedProfileId)\n    }\n    \n    public func getViewHistory(for userId: String) -> [String] {\n        return Array(viewHistory[userId] ?? [])\n    }\n    \n    public func hasViewed(userId: String, profileId: String) -> Bool {\n        return viewHistory[userId]?.contains(profileId) ?? false\n    }\n    \n    // MARK: - Query Methods\n    public func getAvailableProfiles(for userId: String, excludeViewed: Bool = true) -> [ProfileEntitiy] {\n        var availableProfiles = Array(profiles.values)\n        \n        // Exclude self\n        availableProfiles = availableProfiles.filter { $0.id != userId }\n        \n        // Exclude viewed profiles if requested\n        if excludeViewed {\n            let viewed = viewHistory[userId] ?? Set()\n            availableProfiles = availableProfiles.filter { !viewed.contains($0.id) }\n        }\n        \n        // Update like status\n        return availableProfiles.map { profile in\n            updateProfileLikeStatus(profile, likedBy: userId)\n        }\n    }\n    \n    public func getNewProfiles(for userId: String, withinDays days: Int = 3) -> [ProfileEntitiy] {\n        let cutoffDate = Date().addingTimeInterval(-TimeInterval(days * 24 * 60 * 60))\n        \n        return getAvailableProfiles(for: userId)\n            .filter { $0.createdAt > cutoffDate }\n            .sorted { $0.createdAt > $1.createdAt }\n    }\n    \n    public func getMutualLikes(for userId: String) -> [ProfileEntitiy] {\n        guard let myLikes = likes[userId] else { return [] }\n        \n        var mutualLikes: [ProfileEntitiy] = []\n        \n        for profileId in myLikes {\n            if let theirLikes = likes[profileId], theirLikes.contains(userId),\n               let profile = profiles[profileId] {\n                let updatedProfile = updateProfileLikeStatus(profile, likedBy: userId)\n                mutualLikes.append(updatedProfile)\n            }\n        }\n        \n        return mutualLikes\n    }\n    \n    // MARK: - Statistics\n    public func getStatistics(for userId: String) -> MockDataStatistics {\n        let myLikes = likes[userId]?.count ?? 0\n        let likesReceived = likes.values.reduce(0) { count, likedUsers in\n            count + (likedUsers.contains(userId) ? 1 : 0)\n        }\n        let mutualLikes = getMutualLikes(for: userId).count\n        let viewedCount = viewHistory[userId]?.count ?? 0\n        let totalProfiles = profiles.count\n        \n        return MockDataStatistics(\n            totalProfiles: totalProfiles,\n            likesGiven: myLikes,\n            likesReceived: likesReceived,\n            mutualLikes: mutualLikes,\n            profilesViewed: viewedCount,\n            connectionsCount: connections[userId]?.count ?? 0\n        )\n    }\n    \n    // MARK: - Helper Methods\n    private func updateProfileLikeStatus(_ profile: ProfileEntitiy, likedBy userId: String) -> ProfileEntitiy {\n        let isLikedByMe = isLiked(profileId: profile.id, by: userId)\n        \n        return ProfileEntitiy(\n            id: profile.id,\n            nickname: profile.nickname,\n            email: profile.email,\n            profileImage: profile.profileImage,\n            images: profile.images,\n            mbti: profile.mbti,\n            qnas: profile.qnas,\n            gender: profile.gender,\n            height: profile.height,\n            weight: profile.weight,\n            bodyType: profile.bodyType,\n            introduction: profile.introduction,\n            isNew: profile.isNew,\n            isLikedByMe: isLikedByMe,\n            createdAt: profile.createdAt,\n            updatedAt: profile.updatedAt\n        )\n    }\n    \n    // MARK: - Scenario Management\n    public func applyScenario(_ scenario: MockScenario) {\n        switch scenario {\n        case .empty:\n            applyEmptyScenario()\n        case .popular:\n            applyPopularScenario()\n        case .newUser:\n            applyNewUserScenario()\n        default:\n            break\n        }\n    }\n    \n    private func applyEmptyScenario() {\n        likes[\"me\"] = Set()\n        \n        // Remove all likes to me\n        for userId in likes.keys {\n            likes[userId]?.remove(\"me\")\n        }\n        \n        connections[\"me\"] = Set()\n    }\n    \n    private func applyPopularScenario() {\n        let allProfileIds = Array(profiles.keys)\n        let manyLikes = Set(allProfileIds.shuffled().prefix(Int.random(in: 10...15)))\n        \n        // Add many likes to me\n        for profileId in manyLikes {\n            if likes[profileId] == nil {\n                likes[profileId] = Set()\n            }\n            likes[profileId]?.insert(\"me\")\n        }\n    }\n    \n    private func applyNewUserScenario() {\n        // Simulate new user with minimal data\n        likes[\"me\"] = Set()\n        connections[\"me\"] = Set()\n        viewHistory[\"me\"] = Set()\n        \n        // Only a few people like the new user\n        let allProfileIds = Array(profiles.keys)\n        let fewLikes = Set(allProfileIds.shuffled().prefix(Int.random(in: 0...2)))\n        \n        for profileId in fewLikes {\n            if likes[profileId] == nil {\n                likes[profileId] = Set()\n            }\n            likes[profileId]?.insert(\"me\")\n        }\n    }\n    \n    // MARK: - Reset Methods\n    public func reset() {\n        profiles.removeAll()\n        connections.removeAll()\n        likes.removeAll()\n        viewHistory.removeAll()\n        \n        initializeWithDefaultData()\n    }\n    \n    public func resetUserData(userId: String = \"me\") {\n        likes[userId] = Set()\n        connections[userId] = Set()\n        viewHistory[userId] = Set()\n        \n        // Remove from other users' data\n        for otherUserId in likes.keys {\n            likes[otherUserId]?.remove(userId)\n        }\n        \n        for otherUserId in connections.keys {\n            connections[otherUserId]?.remove(userId)\n        }\n    }\n}\n\n// MARK: - Supporting Types\npublic struct MockDataStatistics {\n    public let totalProfiles: Int\n    public let likesGiven: Int\n    public let likesReceived: Int\n    public let mutualLikes: Int\n    public let profilesViewed: Int\n    public let connectionsCount: Int\n    \n    public var summary: String {\n        return \"\"\"\n        총 프로필: \\(totalProfiles)개\n        보낸 좋아요: \\(likesGiven)개\n        받은 좋아요: \\(likesReceived)개\n        서로 좋아요: \\(mutualLikes)개\n        조회한 프로필: \\(profilesViewed)개\n        연결된 사용자: \\(connectionsCount)개\n        \"\"\"\n    }\n}\n\n// MARK: - Debug Extensions\n#if DEBUG\nextension MockDataStore {\n    \n    public func debugPrint() {\n        print(\"=== Mock Data Store Debug ===\")\n        print(\"Profiles: \\(profiles.count)\")\n        print(\"Connections: \\(connections)\")\n        print(\"Likes: \\(likes)\")\n        print(\"View History: \\(viewHistory)\")\n        print(\"===========================\")\n    }\n    \n    public func exportData() -> [String: Any] {\n        return [\n            \"profiles\": profiles.mapValues { $0.nickname },\n            \"connections\": connections,\n            \"likes\": likes,\n            \"viewHistory\": viewHistory\n        ]\n    }\n}\n#endif"