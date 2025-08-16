//
//  AppTextField.swift
//  Presentation
//
//  Created by 신동규 on 8/16/25.
//

import SwiftUI

struct AppTextField: View {
    
    @Binding var text: String
    let placeholder: String
    let isTextFieldFocused: Bool
    var suffix: String?
    
    func setSuffix(_ suffix: String) -> Self {
        var copy = self
        copy.suffix = suffix
        return copy
    }
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .pretendardBody()
                .textFieldStyle(.plain)
            
            if let suffix {
                Text(suffix)
                    .pretendardBody()
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isTextFieldFocused ? Color.accentColor : Color.clear, lineWidth: 2)
                )
        )
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
    }
}
