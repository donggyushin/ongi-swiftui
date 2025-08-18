//
//  ProfileDetailView.swift
//  Presentation
//
//  Created by 신동규 on 8/18/25.
//

import SwiftUI
import Domain
import Kingfisher

public struct ProfileDetailView: View {
    
    @StateObject var model: ProfileDetailViewModel
    
    public init(model: ProfileDetailViewModel) {
        self._model = .init(wrappedValue: model)
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
        .navigationBarBackButtonHidden()
        .onAppear {
            Task {
                try await model.fetchProfile()
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            if let photoURL = model.photoURLOfTheMainGate {
                KFImage(photoURL)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .clipped()
            }
            
            HStack {
                CircleProfileImage(url: model.profilePhotoURL, size: 60)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(model.nickname)
                            .pretendardHeadline()
                        
                        if model.isVerified {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundStyle(.blue)
                                .font(.caption)
                        }
                    }
                    
                    if let mbti = model.mbti {
                        Text(mbti.text)
                            .pretendardCaption()
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
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
            ForEach(0..<maxContentCount, id: \.self) { index in
                let photoIndex = index / 2
                let qnaIndex = index / 2
                
                if index % 2 == 0 && photoIndex < model.photoURLs.count {
                    photoView(url: model.photoURLs[photoIndex])
                } else if index % 2 == 1 && qnaIndex < model.qnas.count {
                    qnaView(qna: model.qnas[qnaIndex])
                } else if model.photoURLs.count > model.qnas.count && photoIndex < model.photoURLs.count {
                    photoView(url: model.photoURLs[photoIndex])
                } else if model.qnas.count > model.photoURLs.count && qnaIndex < model.qnas.count {
                    qnaView(qna: model.qnas[qnaIndex])
                }
            }
        }
    }
    
    private var maxContentCount: Int {
        max(model.photoURLs.count, model.qnas.count) * 2
    }
    
    private func photoView(url: URL) -> some View {
        KFImage(url)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(height: 250)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .clipped()
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
    ProfileDetailView(model: .init(profileId: "1"))
        .preferredColorScheme(.dark)
}
