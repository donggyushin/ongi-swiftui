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
    
    public init(presentation: ProfileCardPresentation) {
        self.presentation = presentation
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
                HStack(alignment: .top, spacing: 12) {
                    // Profile Image
                    CircleProfileImage(url: presentation.profileImage?.url)
                    
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
        return .init(MockProfileRepository().profile1, blur: false)
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
