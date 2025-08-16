//
//  PQnARepository.swift
//  Domain
//
//  Created by 신동규 on 8/16/25.
//

public protocol PQnARepository {
    func getExamples() async throws -> [QnAEntity]
}
