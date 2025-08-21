//
//  SimpleProfile.swift
//  Presentation
//
//  Created by 신동규 on 8/21/25.
//

import SwiftUI

struct SimpleProfile: View {
    
    let profileImage: URL?
    let nickname: String
    let isLikedByMe: Bool
    let blur: Bool
    let isVerified: Bool
    let mbti: String?
    
    var body: some View {
        // Top section with profile image and basic info
        HStack(alignment: .top, spacing: 12) {
            // Profile Image
            CircleProfileImage(url: profileImage)
                .overlay(alignment: .bottomTrailing) {
                    if isLikedByMe {
                        Image(systemName: "suit.heart.fill")
                            .pretendardCaption()
                            .foregroundStyle(.red)
                            .offset(x: 3, y: 3)
                    }
                }
            
            VStack(alignment: .leading, spacing: 4) {
                // Nickname with verification badge
                HStack(spacing: 4) {
                    Text(blur ? "****" : nickname)
                        .pretendardHeadline(.semiBold)
                        .foregroundColor(.white)
                    
                    if isVerified && !blur {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.blue)
                            .font(.caption)
                    }
                }
                
                // MBTI
                if let mbti {
                    Text(blur ? "****" : mbti)
                        .pretendardCaption(.medium)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            
            Spacer()
        }
    }
}
