//
//  ChatView.swift
//  Presentation
//
//  Created by 신동규 on 8/22/25.
//

import SwiftUI
import Domain
import Factory

extension Date {
    func isSameDay(as date: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: date)
    }
}

struct ChatView: View {
    
    @StateObject var model: ChatViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(Array(model.messages.reversed().enumerated()), id: \.element.id) { index, message in
                            let shouldShowDateDivider = shouldShowDateDivider(at: index, in: model.messages.reversed())
                            
                            if shouldShowDateDivider {
                                DateDivider(date: message.createdAt)
                            }
                            
                            MessageRow(
                                message: message,
                                isMyMessage: model.me?.id == message.writer.id
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
        .loading(model.loading)
    }
    
    private func shouldShowDateDivider(at index: Int, in messages: [MessagePresentation]) -> Bool {
        if index == 0 {
            return true
        }
        
        let currentMessage = messages[index]
        let previousMessage = messages[index - 1]
        
        return !currentMessage.createdAt.isSameDay(as: previousMessage.createdAt)
    }
}

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

struct MessageRow: View {
    let message: MessagePresentation
    let isMyMessage: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            if !isMyMessage {
                AsyncImage(url: message.writer.profileImage?.url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(width: 40, height: 40)
                .clipShape(Circle())
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

#if DEBUG
private struct ChatViewPreview: View {
    
    let contentViewModel = Container.shared.contentViewModel()
    
    let vm = ChatViewModel(chatId: "")
    
    var body: some View {
        ChatView(model: vm)
            .task {
                try? await Task.sleep(for: .seconds(3))
                guard let me = vm.messages.first?.writer else { return }
                contentViewModel.me = me
            }
    }
}

#Preview {
    ChatViewPreview()
        .preferredColorScheme(.dark)
}
#endif
