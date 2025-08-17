//
//  PVerificationRepository.swift
//  DataSource
//
//  Created by 신동규 on 8/17/25.
//

public protocol PVerificationRepository {
    func sendCompany(email: String) async throws
    func verify(code: String) async throws
}
