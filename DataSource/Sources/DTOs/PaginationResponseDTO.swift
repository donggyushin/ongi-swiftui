//
//  PaginationResponseDTO.swift
//  DataSource
//
//  Created by 신동규 on 8/22/25.
//

struct PaginationResponseDTO: Decodable {
    let limit: Int
    let hasMore: Bool
    let nextCursor: String?
}
