//
//  MockProfileRepository.swift
//  Presentation
//
//  Created by 신동규 on 8/14/25.
//

import Domain

final class MockProfileRepository: PProfileRepository {
    
    init() { }
    
    func getMe(accessToken: String) async throws -> ProfileEntitiy {
        throw AppError.custom("로그인 안되어져있음")
    }
}
