//
//  ProfileCardPresentation.swift
//  DataSource
//
//  Created by 신동규 on 8/17/25.
//

import Domain
import Foundation

public struct ProfileCardPresentation {
    
    let id: String
    var nickname: String
    let isVerified: Bool
    let profileImage: ImageEntity?
    let backgroundImage: ImageEntity?
    let mbti: MBTIEntity?
    let height: CGFloat?
    let weight: CGFloat?
    let bodyType: BodyType?
    let blur: Bool
    let isLikedByMe: Bool
    let lastTokenAuthAt: Date
    let location: LocationEntity?
    
    var lastLoginDaysAgo: Int {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: lastTokenAuthAt, to: now)
        return components.day ?? 0
    }
    
    public init(_ domain: ProfileEntitiy) {
        id = domain.id
        nickname = domain.nickname
        isVerified = domain.email != nil
        profileImage = domain.profileImage
        backgroundImage = domain.images.randomElement()
        mbti = domain.mbti
        height = domain.height
        weight = domain.weight
        bodyType = domain.bodyType
        blur = domain.isNew
        isLikedByMe = domain.isLikedByMe
        lastTokenAuthAt = domain.lastTokenAuthAt
        location = domain.location 
    }
    
}
