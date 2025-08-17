//
//  ProfileCard.swift
//  DataSource
//
//  Created by 신동규 on 8/17/25.
//

import SwiftUI
import Domain
import ThirdParty

struct ProfileCard: View {
    
    let presentation: ProfileCardPresentation
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Background Image
            if let backgroundImage = presentation.backgroundImage {
                Rectangle()
                    .fill(.clear)
                    .background {
                        KFImage(backgroundImage.url)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .blur(radius: presentation.blur ? 20 : 0)
                            .clipped()
                    }
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
            }
            
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
                HStack(alignment: .top, spacing: 12) {
                    // Profile Image
                    if let profileImage = presentation.profileImage {
                        KFImage(profileImage.url)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 60, height: 60)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        // Nickname with verification badge
                        HStack(spacing: 4) {
                            Text(presentation.blur ? "****" : presentation.nickname)
                                .pretendardHeadline(.semiBold)
                                .foregroundColor(.white)
                            
                            if presentation.isVerified && !presentation.blur {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.blue)
                                    .font(.caption)
                            }
                        }
                        
                        // MBTI
                        if let mbti = presentation.mbti {
                            Text(presentation.blur ? "****" : mbti.text)
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
                
                Spacer()
                
                // Bottom section with physical info
                VStack(alignment: .leading, spacing: 8) {
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
                            
                            if let bodyTypeString = presentation.bodyTypeString {
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
        return .init(MockProfileRepository().profile1, blur: Bool.random())
    }
    
    var body: some View {
        ProfileCard(presentation: presentation)
            .frame(height: 500)
            .preferredColorScheme(.dark)
    }
}

#Preview {
    ProfileCardPreview()
}
#endif
