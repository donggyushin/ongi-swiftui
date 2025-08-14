//
//  LoginView.swift
//  Presentation
//
//  Created by 신동규 on 8/14/25.
//

import SwiftUI
import AuthenticationServices
import Domain
import Factory

public struct LoginView: View {
    
    @StateObject var model: LoginViewModel
    
    public init(model: LoginViewModel) {
        self._model = .init(wrappedValue: model)
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    // Header Section
                    headerSection
                        .frame(height: geometry.size.height * 0.4)
                    
                    appleSignInButton
                        .padding(.horizontal, 24)
                        .padding(.top, 40)
                }
            }
        }
        .background(
            LinearGradient(
                colors: [
                    Color(.systemBackground),
                    Color(.systemGray6)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .ignoresSafeArea()
    }
    
    private var headerSection: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // App Logo/Icon
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 80, height: 80)
                .overlay(
                    Text("온")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                )
            
            VStack(spacing: 8) {
                Text("온기에 오신 것을")
                    .pretendardTitle1()
                    .foregroundColor(.primary)
                
                Text("환영합니다")
                    .pretendardTitle1()
                    .foregroundColor(.primary)
                
                Text("따뜻한 소통을 시작해보세요")
                    .pretendardBody()
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
            }
            
            Spacer()
        }
    }
    
    private var appleSignInButton: some View {
        SignInWithAppleButton(
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                model.handleAppleSignIn(result)
            }
        )
        .signInWithAppleButtonStyle(.black)
        .frame(height: 50)
        .cornerRadius(12)
    }
}

#if DEBUG
private struct LoginViewPreview: View {
    var body: some View {
        LoginView(model: Container.shared.loginViewModel())
    }
}

#Preview {
    LoginViewPreview()
}
#endif


