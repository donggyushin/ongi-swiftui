//
//  MessageRow.swift
//  ongi-swiftui
//
//  Created by 신동규 on 8/30/25.
//

import SwiftUI

struct MessageRow: View {
    let message: MessagePresentation
    let isMyMessage: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            if !isMyMessage {
                CircleProfileImage(url: message.writer.profileImage?.url)
                    .onTapGesture {
                        navigationManager?.append(.profileDetailStack(message.writer.id))
                    }
            } else {
                Spacer()
            }
            
            VStack(alignment: isMyMessage ? .trailing : .leading, spacing: 4) {
                if !isMyMessage {
                    Text(message.writer.nickname)
                        .pretendardBody()
                        .foregroundColor(.primary)
                }
                
                Text(message.text)
                    .pretendardBody()
                    .foregroundColor(isMyMessage ? .white : .primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(isMyMessage ? Color.blue : Color(.systemGray6))
                    .cornerRadius(16)
                
                Text(message.createdAt, style: .time)
                    .pretendardCaption()
                    .foregroundColor(.secondary)
            }
            
            if !isMyMessage {
                Spacer()
            }
        }
        .id(message.id)
    }
}
