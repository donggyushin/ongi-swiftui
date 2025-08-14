//
//  ContentViewModel.swift
//  Presentation
//
//  Created by 신동규 on 8/14/25.
//

import Combine
import Domain

public final class ContentViewModel: ObservableObject {
    
    let profileUseCase: ProfileUseCase
    
    public init(profileUseCase: ProfileUseCase) {
        self.profileUseCase = profileUseCase
    }
}
