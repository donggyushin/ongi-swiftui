//
//  MessageReadInfoEntity.swift
//  Domain
//
//  Created by 신동규 on 8/22/25.
//

import Foundation

public struct MessageReadInfoEntity {
    public let id: String
    public let profileId: String
    public let dateInfoUserViewedRecently: Date
    
    public init(id: String, profileId: String, dateInfoUserViewedRecently: Date) {
        self.id = id
        self.profileId = profileId
        self.dateInfoUserViewedRecently = dateInfoUserViewedRecently
    }
}
