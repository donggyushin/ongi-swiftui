//
//  ZoomableImage.swift
//  Presentation
//
//  Created by 신동규 on 8/23/25.
//

import SwiftUI
import UIKit
import Kingfisher

public struct ZoomableImage: View {
    
    let url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    public var body: some View {
        KFImage(url)
            .resizable()
            .scaledToFit()
    }
}

#Preview {
    ZoomableImage(url: .init(string: "https://res.cloudinary.com/blog-naver-com-donggyu-00/image/upload/v1755952248/profile-images/profile_gallery_001179.faeab893b42e4690857666203dccc57f.1606_1755952246788.jpg")!)
        .ignoresSafeArea()
}
