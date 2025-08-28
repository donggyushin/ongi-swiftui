//
//  ReportViewModel.swift
//  Presentation
//
//  Created by 신동규 on 8/28/25.
//

import SwiftUI
import Domain
import Factory

final class ReportViewModel: ObservableObject {
    
    let targetUserId: String
    
    @Published var content = ""
    @Published var loading = false
    @Published var buttonEnabled = false
    
    let minTextLength = 50
    let maxTextLength = 500
    
    @Injected(\.reportUseCase) private var reportUseCase
    
    init(targetUserId: String) {
        self.targetUserId = targetUserId
    }
    
    @MainActor
    func report() async throws {
        guard loading == false else { return }
        loading = true
        defer { loading = false }
        
        try await reportUseCase.report(profileId: targetUserId, content: content)
    }
}
