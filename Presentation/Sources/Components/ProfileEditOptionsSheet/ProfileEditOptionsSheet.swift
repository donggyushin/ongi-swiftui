//
//  ProfileEditOptionsSheet.swift
//  ongi-swiftui
//
//  Created by 신동규 on 8/19/25.
//

import SwiftUI

public enum ProfileEditOption {
    case profileImage
    case nickname
    case email
    case introduce
    case physicalInfo
    case mbti
    case images
    case qna
}

public struct ProfileEditOptionsSheet: View {
    
    @Binding var isPresent: Bool
    
    @State private var presentEmailEdit = false
    @State private var presentMultipleImagesEdit = false
    @State private var presentIntroduceEdit = false
    @State private var presentMBTIEdit = false
    @State private var presentNicknameEdit = false
    @State private var presentPhysicalInfoEdit = false
    @State private var presentProfileImageEdit = false
    @State private var presentQnAEdit = false
    
    public var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ProfileEditOptionRow(
                        icon: "person.circle",
                        title: "프로필 사진 변경",
                        description: "대표 프로필 사진을 변경하세요"
                    ) {
                        presentProfileImageEdit = true
                    }
                    
                    ProfileEditOptionRow(
                        icon: "textformat",
                        title: "닉네임 변경",
                        description: "다른 사용자에게 보여질 닉네임을 변경하세요"
                    ) {
                        presentNicknameEdit = true
                    }
                    
                    ProfileEditOptionRow(
                        icon: "envelope.badge.fill",
                        title: "이메일 인증",
                        description: "프로필 인증을 위해 이메일을 등록하세요"
                    ) {
                        presentEmailEdit = true
                    }
                    
                    ProfileEditOptionRow(
                        icon: "quote.bubble",
                        title: "자기소개 수정",
                        description: "나를 소개하는 글을 작성해주세요"
                    ) {
                        presentIntroduceEdit = true
                    }
                    
                    ProfileEditOptionRow(
                        icon: "person.2",
                        title: "성별 및 신체정보",
                        description: "성별, 키, 몸무게, 체형 정보를 수정하세요"
                    ) {
                        presentPhysicalInfoEdit = true
                    }
                    
                    ProfileEditOptionRow(
                        icon: "brain.head.profile",
                        title: "MBTI 변경",
                        description: "나의 성격 유형을 업데이트하세요"
                    ) {
                        presentMBTIEdit = true
                    }
                    
                    ProfileEditOptionRow(
                        icon: "photo.on.rectangle.angled",
                        title: "사진 관리",
                        description: "프로필에 표시될 사진들을 추가하거나 삭제하세요"
                    ) {
                        presentMultipleImagesEdit = true
                    }
                    
                    ProfileEditOptionRow(
                        icon: "questionmark.circle",
                        title: "Q&A 관리",
                        description: "질문과 답변을 추가하거나 수정하세요"
                    ) {
                        presentQnAEdit = true 
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationTitle("프로필 수정")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("완료") {
                        isPresent = false
                    }
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
        .sheet(isPresented: $presentPhysicalInfoEdit) {
            OnboardingPhysicalGenderInfoView(model: .init())
                .onComplete(updateProfileSheetDismissed)
        }
        .sheet(isPresented: $presentProfileImageEdit) {
            OnboardingProfileImageView(model: .init())
                .onComplete(updateProfileSheetDismissed)
        }
        .sheet(isPresented: $presentQnAEdit) {
            OnboardingQNAsView(model: .init())
                .onComplete(updateProfileSheetDismissed)
        }
    }
    
    private func updateProfileSheetDismissed() {
        presentEmailEdit = false
        presentMultipleImagesEdit = false
        presentIntroduceEdit = false
        presentMBTIEdit = false
        presentNicknameEdit = false
        presentPhysicalInfoEdit = false
        presentProfileImageEdit = false
        presentQnAEdit = false
    }
}

private struct ProfileEditOptionRow: View {
    let icon: String
    let title: String
    let description: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(.blue)
                    .frame(width: 32, height: 32)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .pretendardSubheadline()
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    
                    Text(description)
                        .pretendardCaption()
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(Color(.systemBackground))
        }
        .buttonStyle(PlainButtonStyle())
        
        Divider()
            .padding(.leading, 68)
    }
}
