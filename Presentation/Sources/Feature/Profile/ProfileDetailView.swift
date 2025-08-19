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
    
    @StateObject var model: ProfileDetailViewModel
    @State private var showingEditOptions = false
    
    @State private var presentEmailEdit = false
    @State private var presentMultipleImagesEdit = false
    @State private var presentIntroduceEdit = false
    @State private var presentMBTIEdit = false
    @State private var presentNicknameEdit = false
    
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
        .scrollIndicators(.never)
        .sheet(isPresented: $showingEditOptions) {
            ProfileEditOptionsSheet(isPresent: $showingEditOptions)
                .onComplete { option in
                    switch option {
                    case .email:
                        presentEmailEdit = true
                    case .images:
                        presentMultipleImagesEdit = true
                    case .introduce:
                        presentIntroduceEdit = true
                    case .mbti:
                        presentMBTIEdit = true
                    case .nickname:
                        presentNicknameEdit = true
                    case .physicalInfo:
                        print("physical info")
                    case .profileImage:
                        print("profile image")
                    case .qna:
                        print("qna")
                    }
                }
        }
        .sheet(isPresented: $presentEmailEdit) {
            OnboardingCompanyEmailVerificationView(model: .init())
                .onNext(updateProfileSheetDismissed)
        }
        .sheet(isPresented: $presentMultipleImagesEdit) {
            OnboardingMultipleImagesView(model: .init())
                .onNextAction(updateProfileSheetDismissed)
        }
        .sheet(isPresented: $presentIntroduceEdit) {
            OnboardingIntroduceView(model: .init())
                .onComplete(updateProfileSheetDismissed)
        }
        .sheet(isPresented: $presentMBTIEdit) {
            OnboardingMBTIView(model: .init())
                .onComplete(updateProfileSheetDismissed)
        }
        .sheet(isPresented: $presentNicknameEdit) {
            OnboardingNicknameView(model: .init())
                .onNextAction(updateProfileSheetDismissed)
        }
    }
    
    private func updateProfileSheetDismissed() {
        presentEmailEdit = false
        presentMultipleImagesEdit = false
        presentIntroduceEdit = false
        presentMBTIEdit = false
        presentNicknameEdit = false
        
        Task {
            try await model.fetchProfile()
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            UserBackgroundImage(url: model.photoURLOfTheMainGate, blur: false)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .frame(height: 400)
            
            HStack {
                CircleProfileImage(url: model.profilePhotoURL, size: 60)
                
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
                        Text(mbti.text)
                            .pretendardCaption()
                            .foregroundStyle(.secondary)
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
                photoView(url: model.photoURLs[photoIndex])
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
                photoView(url: model.photoURLs[photoIndex])
            } else {
                // Q&A가 더 많은 경우
                let qnaIndex = minCount + remainingIndex
                qnaView(qna: model.qnas[qnaIndex])
            }
        }
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
    ProfileDetailView(model: .init(profileId: "me"))
        .onAppear {
            Container.shared.contentViewModel().getMe()
        }
        .preferredColorScheme(.dark)
}
