//
//  ConnectedProfileDTO.swift
//  DataSource
//
//  Created by 신동규 on 8/19/25.
//

struct ConnectedProfileDTO: Decodable {
    let profileId: String
    let addedAt: String
    let isNew: Bool
}
