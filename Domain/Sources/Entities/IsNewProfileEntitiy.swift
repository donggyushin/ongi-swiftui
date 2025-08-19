//
//  IsNewProfileEntitiy.swift
//  Domain
//
//  Created by 신동규 on 8/19/25.
//

import Foundation

public struct IsNewProfileEntitiy {
    public let profileId: String
    public let addedAt: Date
    public let isNew: Bool
    
    public init(profileId: String, addedAt: Date, isNew: Bool) {
        self.profileId = profileId
        self.addedAt = addedAt
        self.isNew = isNew
    }
}
