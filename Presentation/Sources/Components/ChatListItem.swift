//
//  ChatListItem.swift
//  Presentation
//
//  Created by 신동규 on 8/22/25.
//

import SwiftUI
import Domain

struct ChatListItemView: View {
    let chat: ChatEntity
    
    init(chat: ChatEntity, myId: String? = nil) {
        self.chat = chat
        self.myId = myId
    }
    
    private var myId: String?
    public func setMyId(_ value: String?) -> Self {
        var copy = self
        copy.myId = value
        return copy
    }
    
    private var lastMessage: MessageEntity? {
        chat.messages.sorted { $0.createdAt > $1.createdAt }.first
    }
    
    private var otherParticipant: ProfileEntitiy? {
        chat.participants.first
    }
    
    private var hasUnreadMessages: Bool {
        // 읽지 않은 메시지가 있는지 확인하는 로직
        // 실제 구현에서는 messageReadInfos를 활용
        true
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Profile Image
            CircleProfileImage(
                url: otherParticipant?.profileImage?.url,
                size: 40
            )
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    // Nickname
                    Text(otherParticipant?.nickname ?? "알 수 없음")
                        .pretendardSubheadline(.semiBold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    // Time
                    if let lastMessage = lastMessage {
                        Text(formatTime(lastMessage.createdAt))
                            .pretendardCaption2(.regular)
                            .foregroundColor(.secondary)
                    }
                }
                
                HStack {
                    // Last Message
                    if let lastMessage = lastMessage {
                        Text(lastMessage.text)
                            .pretendardBody(.regular)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    } else {
                        Text("메시지가 없습니다")
                            .pretendardBody(.regular)
                            .foregroundColor(.secondary)
                            .italic()
                    }
                    
                    Spacer()
                    
                    // Unread indicator
                    if hasUnreadMessages {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                    }
                }
            }
            
            // Chevron
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(.tertiaryLabel))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .onTapGesture {
            // Navigate to chat detail
            // TODO: Implement navigation to chat detail view
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDate(date, inSameDayAs: now) {
            formatter.dateFormat = "HH:mm"
        } else if calendar.isDate(date, inSameDayAs: calendar.date(byAdding: .day, value: -1, to: now) ?? now) {
            return "어제"
        } else if calendar.component(.year, from: date) == calendar.component(.year, from: now) {
            formatter.dateFormat = "MM/dd"
        } else {
            formatter.dateFormat = "yyyy/MM/dd"
        }
        
        return formatter.string(from: date)
    }
}

