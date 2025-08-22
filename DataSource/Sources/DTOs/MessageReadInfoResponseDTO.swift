//
//  MessageReadInfoResponseDTO.swift
//  DataSource
//
//  Created by 신동규 on 8/22/25.
//

struct MessageReadInfoResponseDTO: Decodable {
    let id: String
    let profileId: String
    let dateInfoUserViewedRecently: String
}
