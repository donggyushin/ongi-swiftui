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
                            let shouldShowProfile = shouldShowProfile(at: index, in: model.messages.reversed())
                            let shouldShowTime = shouldShowTime(at: index, in: model.messages.reversed())
                            
                            if shouldShowDateDivider {
                                DateDivider(date: message.createdAt)
                            }
                            
                            if message.messageType == .leaveChat {
                                LeaveChatMessage(message: message)
                                    .onAppear {
                                        Task {
                                            if message.id == model.messages.last?.id {
                                                try await model.fetchMessages()
                                            }
                                        }
                                    }
                            } else {
                                MessageRow(
                                    message: message,
                                    isMyMessage: model.me?.id == message.writer.id,
                                    showProfile: shouldShowProfile,
                                    showTime: shouldShowTime
                                )
                                .onAppear {
                                    Task {
                                        if message.id == model.messages.last?.id {
                                            try await model.fetchMessages()
                                        }
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
                    
                    ChatSidebar(participants: model.participants, model: .init())
                        .onLeaveChatTap {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                model.showSidebar = false
                            }
                            model.showLeaveChatDialog = true
                        }
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
    
    private func shouldShowProfile(at index: Int, in messages: [MessagePresentation]) -> Bool {
        let currentMessage = messages[index]
        
        // 내 메시지는 항상 프로필을 숨김
        if model.me?.id == currentMessage.writer.id {
            return false
        }
        
        // 마지막 메시지면 항상 프로필 표시
        if index == messages.count - 1 {
            return true
        }
        
        let nextMessage = messages[index + 1]
        
        // 다음 메시지와 작성자가 다르거나, 날짜가 다르면 프로필 표시
        return currentMessage.writer.id != nextMessage.writer.id || 
               !currentMessage.createdAt.isSameDay(as: nextMessage.createdAt)
    }
    
    private func shouldShowTime(at index: Int, in messages: [MessagePresentation]) -> Bool {
        let currentMessage = messages[index]
        
        // 마지막 메시지면 항상 시간 표시
        if index == messages.count - 1 {
            return true
        }
        
        let nextMessage = messages[index + 1]
        
        // 다음 메시지와 작성자가 다르면 시간 표시
        if currentMessage.writer.id != nextMessage.writer.id {
            return true
        }
        
        // 다음 메시지와 분 단위까지 시간이 다르면 시간 표시
        let currentComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: currentMessage.createdAt)
        let nextComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: nextMessage.createdAt)
        
        return currentComponents != nextComponents
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
