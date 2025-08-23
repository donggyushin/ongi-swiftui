//
//  ProfileCard.swift
//  DataSource
//
//  Created by 신동규 on 8/17/25.
//

import SwiftUI
import Domain
import ThirdParty

public struct ProfileCard: View {
    
    let presentation: ProfileCardPresentation
    let isMe: Bool
    
    private var lastLoginText: String {
        let daysAgo = presentation.lastLoginDaysAgo
        switch daysAgo {
        case 0:
            return "오늘 접속"
        case 1:
            return "어제 접속"
        case 2...7:
            return "\(daysAgo)일 전 접속"
        case 8...30:
            return "\(daysAgo)일 전 접속"
        case 31...365:
            let months = daysAgo / 30
            return "\(months)개월 전 접속"
        default:
            let years = daysAgo / 365
            return "\(years)년 전 접속"
        }
    }
    
    public var body: some View {
        ZStack(alignment: .topLeading) {
            // Background Image
            UserBackgroundImage(
                url: presentation.backgroundImage?.url,
                blur: presentation.blur
            )
            
            // Gradient overlay for better text readability
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(0.6),
                    Color.black.opacity(0.3),
                    Color.black.opacity(0.4)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(alignment: .leading, spacing: 12) {
                // Top section with profile image and basic info
                SimpleProfile(
                    profileImage: presentation.profileImage?.url,
                    nickname: presentation.nickname,
                    isLikedByMe: presentation.isLikedByMe,
                    blur: presentation.blur,
                    isVerified: presentation.isVerified,
                    mbti: presentation.mbti?.text
                )
                
                Spacer()
                
                // Bottom section with physical info and last login
                VStack(alignment: .leading, spacing: 8) {
                    // Last login info (only show when not me)
                    if !isMe {
                        HStack {
                            Text(lastLoginText)
                                .pretendardCaption(.regular)
                                .foregroundColor(.white.opacity(0.8))
                            Spacer()
                        }
                    }
                    
                    if let height = presentation.height,
                       let weight = presentation.weight {
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("키")
                                    .pretendardCaption(.regular)
                                    .foregroundColor(.white.opacity(0.7))
                                Text(presentation.blur ? "***cm" : "\(Int(height))cm")
                                    .pretendardCallout(.medium)
                                    .foregroundColor(.white)
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("몸무게")
                                    .pretendardCaption(.regular)
                                    .foregroundColor(.white.opacity(0.7))
                                Text(presentation.blur ? "***kg" : "\(Int(weight))kg")
                                    .pretendardCallout(.medium)
                                    .foregroundColor(.white)
                            }
                            
                            if let bodyTypeString = presentation.bodyType?.text {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("체형")
                                        .pretendardCaption(.regular)
                                        .foregroundColor(.white.opacity(0.7))
                                    Text(presentation.blur ? "***" : bodyTypeString)
                                        .pretendardCallout(.medium)
                                        .foregroundColor(.white)
                                }
                            }
                            
                            Spacer()
                        }
                    }
                }
            }
            .padding(16)
        }
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .ignoresSafeArea()
    }
}

#if DEBUG
private struct ProfileCardPreview: View {
    
    var presentation: ProfileCardPresentation {
        return .init(MockProfileRepository().profile1)
    }
    
    var body: some View {
        ProfileCard(presentation: presentation, isMe: false)
            .frame(height: 500)
            .preferredColorScheme(.dark)
    }
}

#Preview {
    ProfileCardPreview()
}
#endif
