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
                        .setMyId(model.myId)
                    
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

#Preview {
    NavigationView {
        ChatListView(model: .init())
    }
    .preferredColorScheme(.dark)
}
