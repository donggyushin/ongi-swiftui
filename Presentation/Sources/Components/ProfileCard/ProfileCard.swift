//
//  ProfileCard.swift
//  DataSource
//
//  Created by 신동규 on 8/17/25.
//

import SwiftUI
import Domain
import ThirdParty
import Factory

public struct ProfileCard: View {
    
    let presentation: ProfileCardPresentation
    let isMe: Bool
    var myLocation: LocationEntity?
    @State private var isAnimating = false
    
    public func setMyLocation(_ location: LocationEntity?) -> Self {
        var copy = self
        copy.myLocation = location
        return copy 
    }
    
    private var lastLoginInfo: (text: String, color: Color, icon: String) {
        let daysAgo = presentation.lastLoginDaysAgo
        switch daysAgo {
        case 0:
            return ("지금 온라인", .green, "circle.fill")
        case 1:
            return ("어제 접속", .yellow, "clock.fill")
        case 2...7:
            return ("\(daysAgo)일 전 접속", .orange, "clock")
        case 8...30:
            return ("\(daysAgo)일 전 접속", .red.opacity(0.8), "clock")
        case 31...365:
            let months = daysAgo / 30
            return ("\(months)개월 전 접속", .gray, "moon.fill")
        default:
            let years = daysAgo / 365
            return ("\(years)년 전 접속", .gray.opacity(0.6), "moon.fill")
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
                    // Distance info (only show when both locations exist and not me)
                    if !isMe,
                       let myLocation = myLocation,
                       let userLocation = presentation.location {
                        HStack {
                            Image(systemName: "location.fill")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.7))
                            Text("약 \(myLocation.formattedDistance(to: userLocation)) 떨어짐")
                                .pretendardCaption(.regular)
                                .foregroundColor(.white.opacity(0.8))
                            Spacer()
                        }
                    }
                    
                    // Last login info (only show when not me)
                    if !isMe {
                        HStack(spacing: 6) {
                            Image(systemName: lastLoginInfo.icon)
                                .font(.caption2)
                                .foregroundColor(lastLoginInfo.color)
                            
                            Text(lastLoginInfo.text)
                                .pretendardCaption(.medium)
                                .foregroundColor(lastLoginInfo.color)
                            
                            if presentation.lastLoginDaysAgo == 0 {
                                // Pulsing animation for online users
                                Circle()
                                    .fill(lastLoginInfo.color)
                                    .frame(width: 4, height: 4)
                                    .scaleEffect(isAnimating ? 1.3 : 1.0)
                                    .opacity(isAnimating ? 0.5 : 1.0)
                                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isAnimating)
                                    .onAppear {
                                        isAnimating = true
                                    }
                            }
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.black.opacity(0.3))
                                .overlay(
                                    Capsule()
                                        .stroke(lastLoginInfo.color.opacity(0.3), lineWidth: 0.5)
                                )
                        )
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
            .setMyLocation(.init(id: "", latitude: 50, longitude: 50, createdAt: Date(), updatedAt: Date()))
            .frame(height: 500)
            .preferredColorScheme(.dark)
            .onAppear {
                Task {
                    try await Container.shared.contentViewModel().getMe()
                }
            }
    }
}

#Preview {
    ProfileCardPreview()
}
#endif
