//
//  ProfileListView.swift
//  Presentation
//
//  Created by 신동규 on 8/14/25.
//

import SwiftUI
import Domain
import Factory

public struct ProfileListView: View {
    
    @StateObject var model: ProfileListViewModel
    @Namespace private var heroNamespace
    @State private var currentIndex: Int = 0
    
    public init(model: ProfileListViewModel) {
        self._model = .init(wrappedValue: model)
    }
    
    public var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.pink.opacity(0.1),
                    Color.purple.opacity(0.05),
                    Color.white
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                if model.loading {
                    loadingView
                } else if model.profiles.isEmpty {
                    emptyStateView
                } else {
                    profileCardsView
                }
                
                Spacer()
            }
        }
        .onAppear {
            Task {
                try await model.fetchConnectionList()
            }
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("새로운 인연들")
                        .pretendardTitle2(.bold)
                        .foregroundColor(.primary)
                    
                    Text("매칭된 분들의 프로필을 확인해보세요")
                        .pretendardSubheadline(.medium)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Profile count indicator
                if !model.profiles.isEmpty {
                    Text("\(currentIndex + 1) / \(model.profiles.count)")
                        .pretendardCaption(.medium)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.primary.opacity(0.1))
                        .cornerRadius(12)
                }
            }
            
            // New profiles indicator
            if !model.newProfilesIds.isEmpty {
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .font(.caption)
                        .foregroundColor(.orange)
                    
                    Text("새로운 프로필 \(model.newProfilesIds.count)개")
                        .pretendardCaption(.semiBold)
                        .foregroundColor(.orange)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(12)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var profileCardsView: some View {
        VStack(spacing: 20) {
            // Horizontal ScrollView with ProfileCards
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        ForEach(Array(model.profiles.enumerated()), id: \.element.id) { index, profile in
                            let isNew = model.newProfilesIds.contains(profile.id)
                            
                            ProfileCard(
                                presentation: ProfileCardPresentation(profile, blur: isNew)
                            )
                            .frame(width: UIScreen.main.bounds.width - 40)
                            .id(index)
                            .overlay(
                                // New badge
                                isNew ? newBadgeView : nil,
                                alignment: .topTrailing
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .scrollTargetBehavior(.viewAligned)
                .onChange(of: currentIndex) { _, newIndex in
                    withAnimation(.easeInOut(duration: 0.5)) {
                        proxy.scrollTo(newIndex, anchor: .center)
                    }
                }
            }
            
            // Page dots indicator
            if model.profiles.count > 1 {
                pageDotsView
            }
        }
        .frame(height: 520)
    }
    
    private var newBadgeView: some View {
        HStack(spacing: 4) {
            Image(systemName: "sparkles.rectangle.stack.fill")
                .font(.caption2)
            Text("NEW")
                .pretendardCaption2(.bold)
        }
        .foregroundColor(.white)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.orange, Color.red]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(8)
        .shadow(color: .orange.opacity(0.3), radius: 4, x: 0, y: 2)
        .offset(x: -12, y: 12)
    }
    
    private var pageDotsView: some View {
        HStack(spacing: 8) {
            ForEach(0..<model.profiles.count, id: \.self) { index in
                Circle()
                    .fill(index == currentIndex ? Color.primary : Color.primary.opacity(0.3))
                    .frame(width: 8, height: 8)
                    .scaleEffect(index == currentIndex ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: currentIndex)
            }
        }
        .padding(.top, 16)
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.pink)
            
            Text("새로운 인연을 찾고 있어요...")
                .pretendardCallout(.medium)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.2.circle")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            
            VStack(spacing: 8) {
                Text("아직 매칭된 프로필이 없어요")
                    .pretendardHeadline(.semiBold)
                    .foregroundColor(.primary)
                
                Text("조금 더 기다려보세요!\n새로운 인연이 곧 나타날 거예요")
                    .pretendardCallout(.medium)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 40)
    }
}

#Preview {
    ProfileListView(model: .init())
        .preferredColorScheme(.dark)
}
