//
//  VerificationRepository.swift
//  DataSource
//
//  Created by 신동규 on 8/17/25.
//

import Domain

public final class VerificationRepository: PVerificationRepository {
    public func sendCompany(email: String) async throws {
        try await verificationRemoteDataSource.sendCompany(email: email)
    }
    
    let verificationRemoteDataSource = VerificationRemoteDataSource()
    
    public init() { }
}
