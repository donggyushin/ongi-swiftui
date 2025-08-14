//
//  APIResponse.swift
//  Domain
//
//  Created by 신동규 on 8/14/25.
//

import Foundation

struct APIResponse<T: Decodable> {
    let success: Bool
    let data: T?
    let message: Bool?
    let error: Bool?
}
