//
//  OnboardingView.swift
//  Presentation
//
//  Created by 신동규 on 8/15/25.
//

import SwiftUI
import Factory
import Domain

public struct OnboardingView: View {
    
    @StateObject var model: OnboardingViewModel
    
    public init(model: OnboardingViewModel) {
        self._model = .init(wrappedValue: model)
    }
    
    public var body: some View {
        Text("온보딩 화면")
            .pretendardTitle2()
    }
}

#if DEBUG
private struct OnboardingViewPreview: View {
    var body: some View {
        OnboardingView(model: Container.shared.onboardingViewModel())
    }
}

#Preview {
    OnboardingViewPreview()
}
#endif
