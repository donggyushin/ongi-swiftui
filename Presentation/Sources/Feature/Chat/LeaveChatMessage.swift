//
//  LeaveChatMessage.swift
//  ongi-swiftui
//
//  Created by 신동규 on 8/30/25.
//

import SwiftUI

struct LeaveChatMessage: View {
    let message: MessagePresentation
    
    var body: some View {
        HStack {
            Spacer()
            
            HStack(spacing: 8) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Text("\(message.writer.nickname)님이 채팅방을 나갔습니다")
                    .pretendardCaption()
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color(.systemGray5))
            .cornerRadius(12)
            
            Spacer()
        }
        .padding(.vertical, 4)
        .id(message.id)
        
    }
}
