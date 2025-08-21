//
//  ProfileListLikeMeItem.swift
//  Presentation
//
//  Created by 신동규 on 8/21/25.
//

import SwiftUI
import Domain
import ThirdParty

public struct ProfileListLikeMeItem: View {
    
    let profile: ProfileEntitiy
    let onChatButtonTapped: () -> Void
    
    public init(profile: ProfileEntitiy, onChatButtonTapped: @escaping () -> Void) {
        self.profile = profile
        self.onChatButtonTapped = onChatButtonTapped
    }
    
    public var body: some View {
        HStack(spacing: 16) {
            // Profile Image
            CircleProfileImage(url: profile.profileImage?.url)
                .frame(width: 60, height: 60)
            
            VStack(alignment: .leading, spacing: 4) {
                // Nickname
                HStack(spacing: 6) {
                    Text(profile.nickname)
                        .pretendardSubheadline(.semiBold)
                        .foregroundColor(.primary)
                    
                    if profile.isNew {
                        Text("NEW")
                            .pretendardCaption2(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [.orange, .red]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(6)
                    }
                }
                
                // MBTI and basic info
                HStack(spacing: 8) {
                    if let mbti = profile.mbti {
                        Text(mbti.text)
                            .pretendardCaption(.medium)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color(.systemGray5))
                            .cornerRadius(6)
                    }
                    
                    if let height = profile.height {
                        Text("\(Int(height))cm")
                            .pretendardCaption(.medium)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                
                // Introduction preview
                if let introduction = profile.introduction, !introduction.isEmpty {
                    Text(introduction)
                        .pretendardCaption(.regular)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
            }
            
            Spacer()
            
            // Heart indicator if liked by me
            if profile.isLikedByMe {
                Image(systemName: "heart.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.pink)
            }
            
            // Chat Button
            Button(action: onChatButtonTapped) {
                HStack(spacing: 6) {
                    Image(systemName: "message.fill")
                        .font(.system(size: 14, weight: .medium))
                    
                    Text("채팅")
                        .pretendardCaption(.semiBold)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.pink, .purple]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
    }
}

#Preview {
    VStack(spacing: 0) {
        ProfileListLikeMeItem(profile: MockProfileRepository().profile1) {
            print("Chat button tapped")
        }
        Divider()
        ProfileListLikeMeItem(profile: MockProfileRepository().profile2) {
            print("Chat button tapped")
        }
        Divider()
        ProfileListLikeMeItem(profile: MockProfileRepository().profile3) {
            print("Chat button tapped")
        }
    }
    .preferredColorScheme(.dark)
}