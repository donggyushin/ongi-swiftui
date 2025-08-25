//
//  ReportStatusDTO+Mapper.swift
//  DataSource
//
//  Created by 신동규 on 8/25/25.
//

import Domain

extension ReportStatusDTO {
    func toDomainEntity() -> ReportStatus {
        return .init(isReported: isReported, theyReported: theyReported)
    }
}
