//
//  CircleProfileImage.swift
//  Presentation
//
//  Created by 신동규 on 8/17/25.
//

import SwiftUI
import Kingfisher

struct CircleProfileImage: View {
    
    let url: URL?
    let size: CGFloat = 40
    
    var body: some View {
        if let url {
            KFImage(url)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(Circle())
        } else {
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.gray.opacity(0.3),
                            Color.gray.opacity(0.6)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
                .overlay {
                    Image(systemName: "person.fill")
                        .font(.system(size: size * 0.4))
                        .foregroundColor(.white.opacity(0.8))
                }
        }
    }
}

#Preview {
    CircleProfileImage(url: nil)
        .preferredColorScheme(.dark)
}
