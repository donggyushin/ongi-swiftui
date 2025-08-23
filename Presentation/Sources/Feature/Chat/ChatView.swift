//
//  ChatView.swift
//  Presentation
//
//  Created by 신동규 on 8/22/25.
//

import SwiftUI
import Domain

struct ChatView: View {
    
    @StateObject var model: ChatViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(model.messages.reversed(), id: \.id) { message in
                            MessageRow(
                                message: message,
                                participant: model.participants.first { $0.id == message.writerProfileId }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
                .onChange(of: model.messages.count) { _, _ in
                    if let lastMessage = model.messages.first {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            MessageInputView(
                text: $model.text,
                onSend: {
                    Task {
                        try? await model.sendMessage()
                    }
                }
            )
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            try? await model.fetchMessages()
        }
    }
}

struct MessageRow: View {
    let message: MessageEntity
    let participant: ProfileEntitiy?
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            AsyncImage(url: participant?.profileImage?.url) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(Color.gray.opacity(0.3))
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(participant?.nickname ?? "Unknown")
                    .pretendardBody()
                    .foregroundColor(.primary)
                
                Text(message.text)
                    .pretendardBody()
                    .foregroundColor(.primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                
                Text(message.createdAt, style: .time)
                    .pretendardCaption()
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .id(message.id)
    }
}

struct MessageInputView: View {
    @Binding var text: String
    let onSend: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            TextField("메시지를 입력하세요", text: $text)
                .pretendardBody()
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                .cornerRadius(20)
            
            Button(action: onSend) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title2)
                    .foregroundColor(text.isEmpty ? .gray : .blue)
            }
            .disabled(text.isEmpty)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
}

#Preview {
    ChatView(model: .init(chatId: "chatId"))
        .preferredColorScheme(.dark)
}
