//
//  ReportRepository.swift
//  DataSource
//
//  Created by 신동규 on 8/28/25.
//

import Domain
import Foundation

public final class ReportRepository: PReportRepository {
    
    let reportRemoteDataSource = ReportRemoteDataSource()
    
    public func report(profileId: String, content: String) async throws {
        try await reportRemoteDataSource.report(profileId: profileId, content: content)
    }
    
    public init() { }
}
