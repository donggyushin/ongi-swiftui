//
//  SettingView.swift
//  Presentation
//
//  Created by 신동규 on 8/21/25.
//

import SwiftUI
import Domain
import Factory
import MessageUI

struct SettingView: View {
    
    @StateObject var model: SettingViewModel
    @State private var presentLogoutDialog = false
    @State private var presentMailCompose = false
    @State private var presentMailUnavailableDialog = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Profile Section
                if let me = model.me {
                    profileSection(me)
                }
                
                // Menu Items
                menuItemsSection
                
                // Logout Button
                logoutButton
                
                Rectangle()
                    .fill(.clear)
                    .frame(height: 60)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.large)
        .modifier(BackgroundModifier())
        .dialog(message: "로그아웃 하시겠습니까?", primaryAction: {
            Task {
                try await model.logout()
            }
        }, isPresented: $presentLogoutDialog)
        .dialog(message: "메일 앱을 사용할 수 없습니다. 기기에 메일 계정이 설정되어 있는지 확인해주세요.", isPresented: $presentMailUnavailableDialog)
        .sheet(isPresented: $presentMailCompose) {
            MailComposeView(recipients: ["donggyu9410@gmail.com"], subject: "온기 앱 피드백", messageBody: "안녕하세요,\n\n온기 앱에 대한 피드백이나 문의사항을 적어주세요.\n\n")
        }
    }
    
    @ViewBuilder
    private func profileSection(_ me: ProfileEntitiy) -> some View {
        SimpleProfile(
            profileImage: me.profileImage?.url,
            nickname: me.nickname,
            isLikedByMe: false,
            blur: false,
            isVerified: me.email?.isEmpty == false,
            mbti: me.mbti?.text
        )
    }
    
    private var menuItemsSection: some View {
        VStack(spacing: 12) {
            // Chat List Button
            menuItem(
                icon: "message.fill",
                iconColor: .blue,
                title: "채팅",
                subtitle: "대화 목록을 확인하세요"
            ) {
                navigationManager?.append(.chatList)
            }
            
            // Like Me Users Button
            menuItem(
                icon: "heart.fill",
                iconColor: .pink,
                title: "나를 좋아하는 사람들",
                subtitle: "관심을 보인 사용자들을 확인하세요"
            ) {
                navigationManager?.append(.profileListLikeMe)
            }
            
            // Contact Developer Button
            menuItem(
                icon: "envelope.fill",
                iconColor: .gray,
                title: "개발자에게 편지쓰기",
                subtitle: "피드백이나 문의사항을 보내주세요"
            ) {
                if MFMailComposeViewController.canSendMail() {
                    presentMailCompose = true
                } else {
                    presentMailUnavailableDialog = true
                }
            }
        }
    }
    
    private func menuItem(
        icon: String,
        iconColor: Color,
        title: String,
        subtitle: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .pretendardSubheadline(.semiBold)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .pretendardCaption(.medium)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
        }
        .buttonStyle(.plain)
    }
    
    private var logoutButton: some View {
        Button {
            presentLogoutDialog = true
        } label: {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 16, weight: .medium))
                
                Text("로그아웃")
                    .pretendardSubheadline(.semiBold)
            }
            .foregroundColor(.red)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.red.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.red.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
        .padding(.top, 20)
    }
}



#Preview {
    NavigationView {
        SettingView(model: .init())
            .onAppear {
                Task {
                    try await Container.shared.contentViewModel().getMe()
                }
            }
    }
    .preferredColorScheme(.dark)
}
