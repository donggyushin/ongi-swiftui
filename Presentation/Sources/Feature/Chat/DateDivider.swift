//
//  DateDivider.swift
//  ongi-swiftui
//
//  Created by 신동규 on 8/30/25.
//

import SwiftUI

struct DateDivider: View {
    let date: Date
    
    var body: some View {
        HStack {
            Rectangle()
                .fill(Color(.systemGray4))
                .frame(height: 0.5)
            
            Text(date, style: .date)
                .pretendardCaption()
                .foregroundColor(.secondary)
                .padding(.horizontal, 12)
                .background(Color(.systemBackground))
            
            Rectangle()
                .fill(Color(.systemGray4))
                .frame(height: 0.5)
        }
        .padding(.vertical, 8)
    }
}
