//
//  EmailLoginComponent.swift
//  Presentation
//
//  Created by 신동규 on 9/1/25.
//

import SwiftUI

struct EmailLoginComponent: View {
    
    @State private var password = ""
    
    var passwordCompletion: ((String) -> ())?
    func onPasswordCompletion(_ action: ((String) -> ())?) -> Self {
        var copy = self
        copy.passwordCompletion = action
        return copy
    }
    
    private var isPasswordValid: Bool {
        password.count >= 2
    }
    
    var body: some View {
        VStack(spacing: 20) {
            SecureField("비밀번호를 입력하세요", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textContentType(.password)
            
            Button(action: {
                passwordCompletion?(password)
            }) {
                Text("다음")
                    .frame(maxWidth: .infinity)
                    .background(isPasswordValid ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(!isPasswordValid)
        }
        .padding()
    }
}
