//
//  EmailInputViewModel.swift
//  Presentation
//
//  Created by 신동규 on 9/1/25.
//

import SwiftUI
import Domain
import Combine
import Factory

final class EmailInputViewModel: ObservableObject {
    @Published var email = ""
    
    init() { }
}
