//
//  ChatListView.swift
//  Presentation
//
//  Created by 신동규 on 8/22/25.
//

import SwiftUI
import Domain

struct ChatListView: View {
    
    @StateObject var model: ChatListViewModel
    
    var body: some View {
        ZStack {
            if model.loading && model.chats.isEmpty {
                ProgressView()
                    .scaleEffect(1.2)
            } else if model.chats.isEmpty {
                emptyStateView
            } else {
                chatListView
            }
        }
        .navigationTitle("채팅")
        .refreshable {
            await model.refresh()
        }
        .task {
            if model.chats.isEmpty {
                await model.fetchChats()
            }
        }
        .modifier(BackgroundModifier())
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "message")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("아직 채팅방이 없어요")
                .pretendardHeadline(.medium)
                .foregroundColor(.primary)
            
            Text("새로운 인연과 대화를 시작해보세요")
                .pretendardBody(.regular)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 40)
    }
    
    private var chatListView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(model.chats, id: \.id) { chat in
                    ChatListItemView(chat: chat)
                    
                    if chat.id != model.chats.last?.id {
                        Divider()
                            .padding(.leading, 80)
                    }
                }
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
    }
}

private struct ChatListItemView: View {
    let chat: ChatEntity
    
    private var lastMessage: MessageEntity? {
        chat.messages.sorted { $0.createdAt > $1.createdAt }.first
    }
    
    private var otherParticipant: ProfileEntitiy? {
        chat.participants.first
    }
    
    private var hasUnreadMessages: Bool {
        // 읽지 않은 메시지가 있는지 확인하는 로직
        // 실제 구현에서는 messageReadInfos를 활용
        false
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Profile Image
            CircleProfileImage(
                url: otherParticipant?.profileImage?.url,
                size: 56
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

#Preview {
    ChatListView(model: .init())
        .preferredColorScheme(.dark)
}
