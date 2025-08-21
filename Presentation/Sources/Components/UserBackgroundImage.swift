//
//  UserBackgroundImage.swift
//  Presentation
//
//  Created by 신동규 on 8/17/25.
//

import SwiftUI
import Kingfisher

struct UserBackgroundImage: View {
    
    let url: URL?
    let blur: Bool
    
    var body: some View {
        if let url {
            Rectangle()
                .fill(.clear)
                .background {
                    KFImage(url)
                        .placeholder {
                            placeholder
                        }
                        .resizable()
                        .scaledToFill()
                        .aspectRatio(contentMode: .fill)
                        .blur(radius: blur ? 20 : 0)
                        .clipped()
                }
        } else {
            placeholder
        }
    }
    
    private var placeholder: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.accentColor.opacity(0.6),
                        Color.purple.opacity(0.8),
                        Color.pink.opacity(0.6)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay {
                // Subtle pattern overlay
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 120, height: 120)
                        .offset(x: -50, y: -30)
                    
                    Circle()
                        .fill(Color.white.opacity(0.05))
                        .frame(width: 80, height: 80)
                        .offset(x: 60, y: 40)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 100, height: 60)
                        .rotationEffect(.degrees(25))
                        .offset(x: 30, y: -60)
                }
            }
    }
}
