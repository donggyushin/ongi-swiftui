//
//  ChatSidebar.swift
//  ongi-swiftui
//
//  Created by 신동규 on 8/30/25.
//

import SwiftUI
import Domain

struct ChatSidebar: View {
    let participants: [ProfileEntitiy]
    var leaveChatTap: (() -> Void) = {}
    func onLeaveChatTap(_ action: @escaping (() -> Void)) -> Self {
        var copy = self
        copy.leaveChatTap = action
        return copy
    }
    
    init(participants: [ProfileEntitiy]) {
        self.participants = participants
    }
    
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
            
            // Participants
            VStack(alignment: .leading, spacing: 8) {
                Text("참가자")
                    .pretendardCaption(.semiBold)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 20)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(participants, id: \.id) { participant in
                            VStack(spacing: 4) {
                                CircleProfileImage(url: participant.profileImage?.url, size: 50)
                                
                                Text(participant.nickname)
                                    .pretendardCaption2(.medium)
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                                    .frame(maxWidth: 60)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .padding(.vertical, 16)
            
            Divider()
            
            // Menu Items
            VStack(spacing: 0) {
                Button(action: leaveChatTap) {
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
