//
//  ChatView.swift
//  Presentation
//
//  Created by 신동규 on 8/22/25.
//

import SwiftUI
import Domain
import Factory
import Combine

extension Date {
    func isSameDay(as date: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: date)
    }
}

struct ChatView: View {
    
    @StateObject var model: ChatViewModel
    @FocusState var inputFocus
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        MannerMessage()
                        
                        ForEach(Array(model.messages.reversed().enumerated()), id: \.element.id) { index, message in
                            let shouldShowDateDivider = shouldShowDateDivider(at: index, in: model.messages.reversed())
                            
                            if shouldShowDateDivider {
                                DateDivider(date: message.createdAt)
                            }
                            
                            if message.messageType == .leaveChat {
                                LeaveChatMessage(message: message)
                            } else {
                                MessageRow(
                                    message: message,
                                    isMyMessage: model.me?.id == message.writer.id
                                )
                            }
                            .onAppear {
                                Task {
                                    if message.id == model.messages.last?.id {
                                        try await model.fetchMessages()
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
                .onReceive(model.scrollToMessageSubject) { messageId in
                    if let messageId {
                        proxy.scrollTo(messageId, anchor: .top)
                    } else if let lastMessage = model.messages.first {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: inputFocus) { a, b in
                    if a == false && b == true {
                        Task {
                            try await Task.sleep(for: .milliseconds(500))
                            if let lastMessage = model.messages.first {
                                withAnimation {
                                    proxy.scrollTo(lastMessage.id, anchor: .bottom)
                                }
                            }
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
            .focused($inputFocus)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        model.showSidebar.toggle()
                    }
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .foregroundColor(.primary)
                }
            }
        }
        .task {
            try? await model.fetchMessages()
        }
        .loading(model.loading)
        .onTapGesture {
            inputFocus = false
        }
        .dialog(
            title: "채팅방 나가기",
            message: "정말로 채팅방을 나가시겠습니까?\n나가게 되면 대화 내용이 모두 삭제됩니다.",
            primaryButtonText: "나가기",
            secondaryButtonText: "취소",
            primaryAction: {
                Task {
                    try await model.leaveChat()
                }
            },
            secondaryAction: {
                model.showLeaveChatDialog = false
            },
            isPresented: $model.showLeaveChatDialog
        )
        .overlay {
            // Sidebar
            if model.showSidebar {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            model.showSidebar = false
                        }
                    }
                
                HStack {
                    Spacer()
                    
                    ChatSidebar(
                        onLeaveChatTap: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                model.showSidebar = false
                            }
                            model.showLeaveChatDialog = true
                        }
                    )
                }
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
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

struct MannerMessage: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "heart.fill")
                .font(.title2)
                .foregroundColor(.pink)
            
            VStack(spacing: 4) {
                Text("따뜻한 만남의 시작")
                    .pretendardTitle3()
                    .foregroundColor(.primary)
                
                Text("진실한 마음으로 서로를 알아가며\n특별한 인연을 만들어보세요 💕")
                    .pretendardBody()
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 24)
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(16)
        .padding(.horizontal, 32)
        .padding(.vertical, 16)
    }
}

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

struct ChatSidebar: View {
    let onLeaveChatTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text("메뉴")
                    .pretendardTitle3(.semiBold)
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 16)
            
            Divider()
            
            // Menu Items
            VStack(spacing: 0) {
                Button(action: onLeaveChatTap) {
                    HStack(spacing: 12) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.red)
                        
                        Text("채팅방 나가기")
                            .pretendardBody(.medium)
                            .foregroundColor(.red)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
                .background(Color(.systemBackground))
            }
            
            Spacer()
        }
        .frame(width: 280)
        .background(Color(.systemBackground))
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: -5, y: 0)
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
