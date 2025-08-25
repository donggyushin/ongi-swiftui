//
//  ReportStatus.swift
//  Domain
//
//  Created by 신동규 on 8/25/25.
//

public struct ReportStatus {
    public let isReported: Bool
    public let theyReported: Bool
    
    public init(isReported: Bool, theyReported: Bool) {
        self.isReported = isReported
        self.theyReported = theyReported
    }
}
