//
//  SplashView.swift
//  Presentation
//
//  Created by 신동규 on 8/15/25.
//

import SwiftUI

struct SplashView: View {
    
    @State var animation1 = false
    @State var animation2 = false
    
    var completion: (() -> ())?
    public func onComplete(_ action: (() -> ())?) -> Self {
        var copy = self
        copy.completion = action
        return copy
    }
    
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [.accentColor, .yellow],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .ignoresSafeArea()
            .overlay {
                VStack(spacing: 0) {
                    Rectangle().fill(.clear)
                        .overlay {
                            VStack(spacing: 20) {
                                if animation1 {
                                    Text("온기")
                                        .foregroundStyle(.white)
                                        .pretendardTitle1()
                                }
                                
                                if animation2 {
                                    Text("따뜻하고 아늑한 데이팅 서비스")
                                        .foregroundStyle(.white)
                                }
                            }
                        }
                    
                    Rectangle().fill(.clear)
                }
            }
            .onAppear {
                Task {
                    try await Task.sleep(for: .seconds(0.7))
                    withAnimation {
                        animation1 = true
                    }
                    
                    try await Task.sleep(for: .seconds(1))
                    withAnimation {
                        animation2 = true
                    }
                    
                    try await Task.sleep(for: .seconds(1.5))
                    completion?()
                }
            }
    }
}

#if DEBUG
private struct SplashViewPreview: View {
    var body: some View {
        SplashView()
    }
}

#Preview {
    SplashViewPreview()
}
#endif
