//
//  ChatSidebar.swift
//  ongi-swiftui
//
//  Created by 신동규 on 8/30/25.
//


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