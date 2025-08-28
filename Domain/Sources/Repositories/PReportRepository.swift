//
//  PReportRepository.swift
//  Domain
//
//  Created by 신동규 on 8/28/25.
//

import Foundation

public protocol PReportRepository {
    func report(profileId: String, content: String) async throws
}
