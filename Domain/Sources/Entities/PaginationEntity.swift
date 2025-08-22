//
//  PaginationEntity.swift
//  Domain
//
//  Created by 신동규 on 8/22/25.
//

public struct PaginationEntity {
    public let limit: Int
    public let hasMore: Bool
    public let nextCursor: String?
    
    public init(limit: Int, hasMore: Bool, nextCursor: String?) {
        self.limit = limit
        self.hasMore = hasMore
        self.nextCursor = nextCursor
    }
}
