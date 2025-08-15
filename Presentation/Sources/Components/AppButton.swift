//
//  AppButton.swift
//  Presentation
//
//  Created by 신동규 on 8/15/25.
//

import SwiftUI

struct AppButton: View {
    
    let text: LocalizedStringKey
    let disabled: Bool
    
    var body: some View {
        Text(text)
            .pretendardBody()
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(!disabled ? Color.accentColor : Color.gray.opacity(0.3))
            .cornerRadius(12)
    }
}
