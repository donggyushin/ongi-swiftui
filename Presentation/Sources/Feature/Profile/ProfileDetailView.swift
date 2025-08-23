//
//  ProfileDetailView.swift
//  Presentation
//
//  Created by 신동규 on 8/18/25.
//

import SwiftUI
import Domain
import Kingfisher
import Factory

public struct ProfileDetailView: View {
    
    let heroNamespace: Namespace.ID
    @StateObject var model: ProfileDetailViewModel
    @State private var showingEditOptions = false
    @State private var isAnimating = false
    
    private var lastLoginInfo: (text: String, color: Color, icon: String) {
        let daysAgo = model.lastLoginDaysAgo
        switch daysAgo {
        case 0:
            return ("지금 온라인", .green, "circle.fill")
        case 1:
            return ("어제 접속", .yellow, "clock.fill")
        case 2...7:
            return ("\(daysAgo)일 전 접속", .orange, "clock")
        case 8...30:
            return ("\(daysAgo)일 전 접속", .red.opacity(0.8), "clock")
        case 31...365:
            let months = daysAgo / 30
            return ("\(months)개월 전 접속", .gray, "moon.fill")
        default:
            let years = daysAgo / 365
            return ("\(years)년 전 접속", .gray.opacity(0.6), "moon.fill")
        }
    }
    
    public init(model: ProfileDetailViewModel, heroNamespace: Namespace.ID) {
        self._model = .init(wrappedValue: model)
        self.heroNamespace = heroNamespace
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerSection
                profileInfoSection
                alternatingContentSection
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .modifier(BackgroundModifier())
        .onAppear {
            Task {
                try await model.fetchProfile()
            }
        }
        .scrollIndicators(.never)
        .sheet(isPresented: $showingEditOptions) {
            Task {
                try await model.fetchProfile()
            }
        } content: {
            ProfileEditOptionsSheet(isPresent: $showingEditOptions)
        }
        .loading(model.loading)
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            
            if let url = model.photoURLOfTheMainGate {
                KFImage(url)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .clipped()
                    .matchedTransitionSource(id: url, in: heroNamespace)
                    .onTapGesture {
                        navigationManager?.append(.zoomableImage(url))
                    }
            }
            
            HStack {
                if let url = model.profilePhotoURL {
                    CircleProfileImage(url: url, size: 60)
                        .matchedTransitionSource(id: url, in: heroNamespace)
                        .onTapGesture {
                            navigationManager?.append(.zoomableImage(url))
                        }
                } else {
                    CircleProfileImage(url: model.profilePhotoURL, size: 60)
                }
                
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(model.nickname)
                            .pretendardHeadline()
                        
                        if model.isVerified {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundStyle(model.gender == .male ? .blue : .pink)
                                .font(.caption)
                        }
                    }
                    
                    if let mbti = model.mbti {
                        HStack(spacing: 8) {
                            Text(mbti.text)
                                .pretendardCaption()
                                .foregroundStyle(.secondary)
                            
                            if let myLocation = model.me?.location,
                               let userLocation = model.location,
                               model.isMe == false {
                                HStack {
                                    Image(systemName: "location.fill")
                                        .font(.caption2)
                                        .foregroundStyle(.primary.opacity(0.7))
                                    Text("약 \(myLocation.formattedDistance(to: userLocation)) 떨어짐")
                                        .pretendardCaption(.regular)
                                        .foregroundStyle(.primary.opacity(0.8))
                                    Spacer()
                                }
                            }
                        }
                    }
                    
                    if !model.isMe {
                        HStack(spacing: 6) {
                            Image(systemName: lastLoginInfo.icon)
                                .font(.caption2)
                                .foregroundColor(lastLoginInfo.color)
                            
                            Text(lastLoginInfo.text)
                                .pretendardCaption(.medium)
                                .foregroundColor(lastLoginInfo.color)
                            
                            if model.lastLoginDaysAgo == 0 {
                                // Pulsing animation for online users
                                Circle()
                                    .fill(lastLoginInfo.color)
                                    .frame(width: 4, height: 4)
                                    .scaleEffect(isAnimating ? 1.3 : 1.0)
                                    .opacity(isAnimating ? 0.5 : 1.0)
                                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isAnimating)
                                    .onAppear {
                                        isAnimating = true
                                    }
                            }
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.gray.opacity(0.5))
                                .overlay(
                                    Capsule()
                                        .stroke(lastLoginInfo.color.opacity(0.3), lineWidth: 0.5)
                                )
                        )
                    }
                }
                
                Spacer()
                
                if model.isMe {
                    Button {
                        showingEditOptions = true
                    } label: {
                        Image(systemName: "pencil")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(.primary)
                            .frame(width: 44, height: 44)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }
                } else {
                    Button {
                        Task {
                            try await model.like()
                        }
                    } label: {
                        Image(systemName: model.isLikedByMe ? "heart.fill" : "heart")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(model.isLikedByMe ? .red : .primary)
                            .frame(width: 44, height: 44)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                            .scaleEffect(model.isLikedByMe ? 1.1 : 1.0)
                    }
                    .animation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0), value: model.isLikedByMe)
                    .sensoryFeedback(.impact(flexibility: .soft, intensity: 0.7), trigger: model.isLikedByMe)
                }
            }
        }
    }
    
    private var profileInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let introduction = model.introduction, !introduction.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("소개")
                        .pretendardSubheadline()
                        .fontWeight(.semibold)
                    
                    Text(introduction)
                        .pretendardBody()
                        .foregroundStyle(.secondary)
                }
            }
            
            if model.gender != nil || model.height != nil || model.weight != nil || model.bodyType != nil {
                VStack(alignment: .leading, spacing: 8) {
                    Text("기본 정보")
                        .pretendardSubheadline()
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 12) {
                        if let gender = model.gender {
                            profileInfoChip(text: gender.text)
                        }
                        if let height = model.height {
                            profileInfoChip(text: "\(Int(height))cm")
                        }
                        if let weight = model.weight {
                            profileInfoChip(text: "\(Int(weight))kg")
                        }
                        if let bodyType = model.bodyType {
                            profileInfoChip(text: bodyType.text)
                        }
                        Spacer()
                    }
                }
            }
        }
    }
    
    private func profileInfoChip(text: String) -> some View {
        Text(text)
            .pretendardCaption()
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color(.systemGray6))
            .clipShape(Capsule())
    }
    
    private var alternatingContentSection: some View {
        VStack(spacing: 20) {
            ForEach(0..<totalContentItems, id: \.self) { index in
                contentItem(at: index)
            }
        }
    }
    
    private var totalContentItems: Int {
        model.photoURLs.count + model.qnas.count
    }
    
    @ViewBuilder
    private func contentItem(at index: Int) -> some View {
        let minCount = min(model.photoURLs.count, model.qnas.count)
        let alternatingCount = minCount * 2
        
        if index < alternatingCount {
            // 교차 표시 구간
            if index % 2 == 0 {
                // 짝수 인덱스 = 사진
                let photoIndex = index / 2
                photoView(url: model.photoURLs[photoIndex], photoIndex: photoIndex)
            } else {
                // 홀수 인덱스 = Q&A
                let qnaIndex = index / 2
                qnaView(qna: model.qnas[qnaIndex])
            }
        } else {
            // 남은 항목들 연속 표시
            let remainingIndex = index - alternatingCount
            
            if model.photoURLs.count > model.qnas.count {
                // 사진이 더 많은 경우
                let photoIndex = minCount + remainingIndex
                photoView(url: model.photoURLs[photoIndex], photoIndex: photoIndex)
            } else {
                // Q&A가 더 많은 경우
                let qnaIndex = minCount + remainingIndex
                qnaView(qna: model.qnas[qnaIndex])
            }
        }
    }
    
    private func photoView(url: URL, photoIndex: Int) -> some View {
        HStack {
            if photoIndex % 2 == 0 {
                // 짝수 인덱스 = 왼쪽 정렬
                KFImage(url)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .clipped()
                    .matchedTransitionSource(id: url, in: heroNamespace)
                    .onTapGesture {
                        navigationManager?.append(.zoomableImage(url))
                    }
                    .frame(height: 350)
                
                Spacer(minLength: 0)
            } else {
                // 홀수 인덱스 = 오른쪽 정렬
                Spacer(minLength: 0)
                
                KFImage(url)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .clipped()
                    .matchedTransitionSource(id: url, in: heroNamespace)
                    .onTapGesture {
                        navigationManager?.append(.zoomableImage(url))
                    }
                    .frame(height: 350)
            }
        }
    }
    
    private func qnaView(qna: QnAEntity) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(qna.question)
                .pretendardSubheadline()
                .fontWeight(.semibold)
            
            Text(qna.answer)
                .pretendardBody()
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    
    @Previewable @Namespace var heroNamespace
    
    ProfileDetailView(model: .init(profileId: "user_001"), heroNamespace: heroNamespace)
        .onAppear {
            Task {
                try await Container.shared.contentViewModel().getMe()
            }
        }
        .preferredColorScheme(.dark)
}
