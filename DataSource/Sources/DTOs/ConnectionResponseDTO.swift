//
//  ConnectionResponseDTO.swift
//  DataSource
//
//  Created by 신동규 on 8/17/25.
//

struct ConnectionResponseDTO: Decodable {
    let profiles: [ProfileResponseDTO]
    let newProfileIds: [String]
    let profileIDsILike: [String]
    let profileIDsLikeMe: [String]
    let count: Int
    let limit: Int
}
