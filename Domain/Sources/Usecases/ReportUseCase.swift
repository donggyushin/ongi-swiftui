//
//  ReportUseCase.swift
//  Domain
//
//  Created by 신동규 on 8/28/25.
//

import Foundation

public final class ReportUseCase {
    let reportRepository: PReportRepository
    
    public init(reportRepository: PReportRepository) {
        self.reportRepository = reportRepository
    }
    
    public func report(profileId: String, content: String) async throws {
        try await reportRepository.report(profileId: profileId, content: content)
    }
}
