//
//  ContentViewModel.swift
//  Presentation
//
//  Created by 신동규 on 8/14/25.
//

import Combine
import Domain

public final class ContentViewModel: ObservableObject {
    
    // MARK: - Dependencies
    // These will be injected when using Factory's composition root
    private let jwtRepository: PJWTRepository
    
    // MARK: - Initialization
    public init(jwtRepository: PJWTRepository) {
        // Allow optional injection for Factory pattern
        self.jwtRepository = jwtRepository
    }
}
