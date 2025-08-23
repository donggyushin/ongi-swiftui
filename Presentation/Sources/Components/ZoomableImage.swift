//
//  ZoomableImage.swift
//  Presentation
//
//  Created by 신동규 on 8/23/25.
//

import SwiftUI
import Kingfisher

public struct ZoomableImage: View {
    
    let url: URL
    
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    @GestureState private var magnification: CGFloat = 1.0
    @GestureState private var dragOffset: CGSize = .zero
    
    private let minScale: CGFloat = 1.0
    private let maxScale: CGFloat = 4.0
    
    public init(url: URL) {
        self.url = url
    }
    
    // 확대/축소 제스처
    private var magnificationGesture: some Gesture {
        MagnificationGesture()
            .updating($magnification) { value, gestureState, _ in
                gestureState = value
            }
            .onEnded { value in
                
                withAnimation(.easeOut(duration: 0.3)) {
                    scale = minScale
                    offset = .zero
                    lastOffset = .zero
                }
            }
    }
    
    // 드래그 제스처
    private var dragGesture: some Gesture {
        DragGesture()
            .updating($dragOffset) { value, gestureState, _ in
                // 확대된 상태에서만 드래그 허용
                guard scale > minScale else { return }
                gestureState = value.translation
            }
            .onEnded { value in
                guard scale > minScale else { return }
                
                withAnimation(.easeOut(duration: 0.3)) {
                    scale = minScale
                    offset = .zero
                    lastOffset = .zero
                }
            }
    }
    
    // 더블 탭 제스처
    private var doubleTapGesture: some Gesture {
        TapGesture(count: 2)
            .onEnded {
                withAnimation(.easeOut(duration: 0.3)) {
                    if scale > minScale {
                        // 원본 크기로 리셋
                        scale = minScale
                        offset = .zero
                        lastOffset = .zero
                    } else {
                        // 2배 확대
                        scale = 2.0
                    }
                }
            }
    }
    
    public var body: some View {
        GeometryReader { geometry in
            KFImage(url)
                .resizable()
                .scaledToFill()
                .scaleEffect(scale * magnification)
                .offset(
                    CGSize(
                        width: offset.width + dragOffset.width,
                        height: offset.height + dragOffset.height
                    )
                )
                .gesture(
                    SimultaneousGesture(
                        magnificationGesture,
                        dragGesture
                    )
                )
                .onTapGesture(count: 2) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        if scale > minScale {
                            scale = minScale
                            offset = .zero
                            lastOffset = .zero
                        } else {
                            scale = 2.0
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .clipped()
        .ignoresSafeArea()
    }
    
    // 오프셋 경계 제한 함수
    private func limitOffset(_ proposedOffset: CGSize) -> CGSize {
        let maxOffsetX = max(0, (UIScreen.main.bounds.width * (scale - 1)) / 2)
        let maxOffsetY = max(0, (UIScreen.main.bounds.height * (scale - 1)) / 2)
        
        return CGSize(
            width: min(max(proposedOffset.width, -maxOffsetX), maxOffsetX),
            height: min(max(proposedOffset.height, -maxOffsetY), maxOffsetY)
        )
    }
}

#Preview {
    ZoomableImage(url: .init(string: "https://res.cloudinary.com/blog-naver-com-donggyu-00/image/upload/v1755952248/profile-images/profile_gallery_001179.faeab893b42e4690857666203dccc57f.1606_1755952246788.jpg")!)
}
