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
    @State private var currentIndex: Int = 0
    let heroNamespace: Namespace.ID
    
    public init(
        model: ProfileListViewModel,
        heroNamespace: Namespace.ID
    ) {
        self._model = .init(wrappedValue: model)
        self.heroNamespace = heroNamespace
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                headerView
                
                if model.loading && model.profiles.isEmpty {
                    loadingView
                } else if model.profiles.isEmpty {
                    emptyStateView
                } else {
                    profileCardsView
                }
                
                Rectangle()
                    .fill(.clear)
                    .frame(height: 80)
                
                if let me = model.me {
                    myProfileCard(me)
                }
                
                Rectangle()
                    .fill(.clear)
                    .frame(height: 60)
            }
        }
        .scrollIndicators(.never)
        .onAppear {
            Task {
                try await model.onAppear()
            }
        }
        .modifier(BackgroundModifier())
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
        // TabView Carousel
        TabView(selection: $currentIndex) {
            ForEach(Array(model.profiles.enumerated()), id: \.element.id) { index, profile in
                ProfileCard(
                    presentation: ProfileCardPresentation(profile)
                )
                .frame(width: UIScreen.main.bounds.width - 40)
                .matchedTransitionSource(id: profile.id, in: heroNamespace)
                .overlay(
                    // New badge
                    profile.isNew ? newBadgeView : nil,
                    alignment: .topTrailing
                )
                .tag(index)
                .padding(.horizontal, 20)
                .onTapGesture {
                    navigationManager?.append(.profileDetail(profile.id))
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .frame(height: 520)
        .animation(.easeInOut(duration: 0.4), value: currentIndex)
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
    
    @ViewBuilder
    func myProfileCard(_ me: ProfileEntitiy) -> some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("내 프로필")
                        .pretendardTitle2(.bold)
                        .foregroundColor(.primary)
                    
                    Text("매칭이 잘 안되시나요? 프로필을 꾸며보세요")
                        .pretendardSubheadline(.medium)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            
            ProfileCard(presentation: .init(me))
                .matchedTransitionSource(id: me.id, in: heroNamespace)
                .frame(height: 200)
                .onTapGesture {
                    navigationManager?.append(.profileDetail(me.id))
                }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    @Previewable @Namespace var heroNamespace
    
    ProfileListView(
        model: .init(),
        heroNamespace: heroNamespace
    )
    .onAppear {
        let contentViewModel = Container.shared.contentViewModel()
        contentViewModel.getMe()
    }
    .preferredColorScheme(.dark)
}
