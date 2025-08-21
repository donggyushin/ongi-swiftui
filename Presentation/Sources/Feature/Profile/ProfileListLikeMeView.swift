//
//  ProfileListLikeMeView.swift
//  Presentation
//
//  Created by 신동규 on 8/21/25.
//

import SwiftUI
import Domain
import Factory

struct ProfileListLikeMeView: View {
    
    @StateObject var model: ProfileListLikeMeViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                headerView
                
                if model.loading && model.profiles.isEmpty {
                    loadingView
                } else if model.profiles.isEmpty {
                    emptyStateView
                } else {
                    profilesListView
                }
                
                Rectangle()
                    .fill(.clear)
                    .frame(height: 60)
            }
        }
        .scrollIndicators(.never)
        .onAppear {
            Task {
                try await model.fetchProfiles()
            }
        }
        .modifier(BackgroundModifier())
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.pink, .red]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "heart.fill")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("나에게 관심있어요!")
                        .pretendardTitle2(.bold)
                        .foregroundColor(.primary)
                    
                    if !model.profiles.isEmpty {
                        Text("\(model.profiles.count)명이 회원님을 좋아해요")
                            .pretendardSubheadline(.medium)
                            .foregroundColor(.secondary)
                    } else {
                        Text("현재 좋아요를 보낸 사람이 없어요")
                            .pretendardSubheadline(.medium)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            }
            
            if !model.profiles.isEmpty {
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .font(.caption)
                        .foregroundColor(.pink)
                    
                    Text("새로운 인연의 시작일 수 있어요!")
                        .pretendardCaption(.semiBold)
                        .foregroundColor(.pink)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.pink.opacity(0.1))
                .cornerRadius(12)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var profilesListView: some View {
        LazyVStack(spacing: 0) {
            ForEach(Array(model.profiles.enumerated()), id: \.element.id) { index, profile in
                ProfileListItem(profile: profile)
                    .onTapGesture {
                        navigationManager?.append(.profileDetail(profile.id))
                    }
                
                if index < model.profiles.count - 1 {
                    Divider()
                        .padding(.horizontal, 20)
                }
            }
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.pink)
            
            Text("좋아요를 보낸 사람들을 찾고 있어요...")
                .pretendardCallout(.medium)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 300)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "heart.slash")
                    .font(.system(size: 40))
                    .foregroundColor(.gray.opacity(0.5))
            }
            
            VStack(spacing: 8) {
                Text("아직 좋아요를 받지 못했어요")
                    .pretendardHeadline(.semiBold)
                    .foregroundColor(.primary)
                
                Text("프로필을 더 매력적으로 꾸며보세요!\n곧 누군가가 회원님에게 관심을 보일 거예요")
                    .pretendardCallout(.medium)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 300)
        .padding(.horizontal, 40)
    }
}

#Preview {
    NavigationView {
        ProfileListLikeMeView(model: .init())
            .preferredColorScheme(.dark)
    }
}
