//
//  ConnectionEntity.swift
//  Domain
//
//  Created by 신동규 on 8/17/25.
//

public struct ConnectionEntity {
    public let profiles: [ProfileEntitiy]
    public let newProfileIds: [String]
    public let profileIDsILike: [String]
    public let profileIDsLikeMe: [String]
    public let count: Int
    public let limit: Int
    
    public init(profiles: [ProfileEntitiy], newProfileIds: [String], profileIDsILike: [String], profileIDsLikeMe: [String], count: Int, limit: Int) {
        self.profiles = profiles
        self.newProfileIds = newProfileIds
        self.profileIDsILike = profileIDsILike
        self.profileIDsLikeMe = profileIDsLikeMe
        self.count = count
        self.limit = limit
    }
    
}
