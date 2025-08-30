//
//  MannerMessage.swift
//  ongi-swiftui
//
//  Created by 신동규 on 8/30/25.
//


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