//
//  LocationEntity.swift
//  Domain
//
//  Created by 신동규 on 8/23/25.
//

import Foundation

public struct LocationEntity {
    public let id: String
    public let latitude: Float
    public let longitude: Float
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(id: String, latitude: Float, longitude: Float, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
