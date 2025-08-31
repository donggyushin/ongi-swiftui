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
    let showProfile: Bool
    let showTime: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            if !isMyMessage {
                if showProfile {
                    CircleProfileImage(url: message.writer.profileImage?.url)
                        .onTapGesture {
                            navigationManager?.append(.profileDetailStack(message.writer.id))
                        }
                } else {
                    CircleProfileImage(url: nil)
                        .opacity(0)
                }
            } else {
                Spacer()
            }
            
            VStack(alignment: isMyMessage ? .trailing : .leading, spacing: 4) {
                if !isMyMessage && showProfile {
                    Text(message.writer.nickname)
                        .pretendardBody()
                        .foregroundColor(.primary)
                }
                
                HStack(alignment: .bottom, spacing: 4) {
                    
                    if showTime && isMyMessage {
                        Text(message.createdAt, style: .time)
                            .pretendardCaption()
                            .foregroundColor(.secondary)
                    }
                    
                    Text(message.text)
                        .pretendardBody()
                        .foregroundColor(isMyMessage ? .white : .primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(isMyMessage ? Color.blue : Color(.systemGray6))
                        .cornerRadius(16)
                    
                    if showTime && !isMyMessage {
                        Text(message.createdAt, style: .time)
                            .pretendardCaption()
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            if !isMyMessage {
                Spacer()
            }
        }
        .id(message.id)
    }
}
