//
//  NotificationsListView.swift
//  Presentation
//
//  Created by 신동규 on 8/29/25.
//

import SwiftUI
import Domain

public struct NotificationsListView: View {
    
    @StateObject var model: NotificationsListViewModel
    
    public init(model: NotificationsListViewModel) {
        self._model = .init(wrappedValue: model)
    }
    
    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                if model.loading && model.notifications.notifications.isEmpty {
                    loadingView
                        .padding(.top, 100)
                } else if model.notifications.notifications.isEmpty {
                    emptyStateView
                        .padding(.top, 100)
                } else {
                    ForEach(model.notifications.notifications, id: \.id) { notification in
                        notificationRow(notification)
                            .onAppear {
                                if notification.id == model.notifications.notifications.last?.id {
                                    Task {
                                        try await model.fetchNotifications()
                                    }
                                }
                            }
                    }
                    
                    if model.loading {
                        ProgressView()
                            .padding(.vertical, 20)
                    }
                }
                
                Rectangle()
                    .fill(.clear)
                    .frame(height: 60)
            }
        }
        .navigationTitle("알림")
        .navigationBarTitleDisplayMode(.large)
        .modifier(BackgroundModifier())
        .onAppear {
            Task {
                try await model.fetchNotifications()
            }
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.orange)
            
            Text("알림을 불러오는 중...")
                .pretendardCallout(.medium)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "bell.slash")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            
            VStack(spacing: 8) {
                Text("알림이 없습니다")
                    .pretendardHeadline(.semiBold)
                    .foregroundColor(.primary)
                
                Text("새로운 알림이 있을 때\n여기에 표시됩니다")
                    .pretendardCallout(.medium)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 40)
    }
    
    @ViewBuilder
    private func notificationRow(_ notification: NotificationEntity) -> some View {
        HStack(spacing: 16) {
            // Notification Icon
            ZStack {
                Circle()
                    .fill(notificationIconColor(type: notification.type).opacity(0.15))
                    .frame(width: 48, height: 48)
                
                Image(systemName: notificationIcon(type: notification.type))
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(notificationIconColor(type: notification.type))
                
                if !notification.isRead {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 8, height: 8)
                        .offset(x: 16, y: -16)
                }
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(notification.title)
                        .pretendardSubheadline(notification.isRead ? .medium : .semiBold)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text(timeAgoString(from: notification.createdAt))
                        .pretendardCaption(.medium)
                        .foregroundColor(.secondary)
                }
                
                if !notification.message.isEmpty {
                    Text(notification.message)
                        .pretendardCallout(.medium)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            Rectangle()
                .fill(notification.isRead ? Color.clear : Color.orange.opacity(0.05))
        )
        .overlay(
            Rectangle()
                .fill(Color(.separator))
                .frame(height: 0.5),
            alignment: .bottom
        )
        .contentShape(Rectangle())
        .onTapGesture {
            Task {
                try await model.tapNotification(notification)
            }
        }
    }
    
    private func notificationIcon(type: String) -> String {
        switch type.lowercased() {
        case "like":
            return "heart.fill"
        case "match":
            return "person.2.fill"
        case "message":
            return "message.fill"
        case "system":
            return "gear.fill"
        default:
            return "bell.fill"
        }
    }
    
    private func notificationIconColor(type: String) -> Color {
        switch type.lowercased() {
        case "like":
            return .pink
        case "match":
            return .green
        case "message":
            return .blue
        case "system":
            return .gray
        default:
            return .orange
        }
    }
    
    private func timeAgoString(from date: Date) -> String {
        let now = Date()
        let timeInterval = now.timeIntervalSince(date)
        
        let minutes = Int(timeInterval / 60)
        let hours = Int(timeInterval / 3600)
        let days = Int(timeInterval / 86400)
        
        if days > 0 {
            return "\(days)일 전"
        } else if hours > 0 {
            return "\(hours)시간 전"
        } else if minutes > 0 {
            return "\(minutes)분 전"
        } else {
            return "방금 전"
        }
    }
}

#Preview {
    NavigationView {
        NotificationsListView(model: .init())
    }
    .preferredColorScheme(.dark)
}
