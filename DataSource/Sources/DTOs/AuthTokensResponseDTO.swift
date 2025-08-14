//
//  AuthTokensResponseDTO.swift
//  Domain
//
//  Created by 신동규 on 8/14/25.
//

struct AuthTokensResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
}
