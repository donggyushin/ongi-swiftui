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
    
    public init(_ domain: ProfileEntitiy, blur: Bool) {
        id = domain.id
        nickname = domain.nickname
        isVerified = domain.email != nil
        profileImage = domain.profileImage
        backgroundImage = domain.images.randomElement()
        mbti = domain.mbti
        height = domain.height
        weight = domain.weight
        bodyType = domain.bodyType
        self.blur = blur
    }
    
    public var bodyTypeString: String? {
        guard let bodyType else { return nil }
        
        switch bodyType {
        case .slim:
            return "마른"
        case .normal:
            return "보통"
        case .chubby:
            return "통통"
        case .large:
            return "큰"
        }
    }
    
}
