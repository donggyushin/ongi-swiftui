//
//  LoginView.swift
//  DataSource
//
//  Created by 신동규 on 8/14/25.
//

import SwiftUI
import Domain

public struct LoginView: View {
    
    @StateObject var model: LoginViewModel
    
    public init(model: LoginViewModel) {
        self._model = .init(wrappedValue: model)
    }
    
    public var body: some View {
        Text("로그인 화면")
    }
}
