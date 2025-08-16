//
//  OnboardingMultipleImagesView.swift
//  Presentation
//
//  Created by 신동규 on 8/15/25.
//

import SwiftUI
import Domain
import Factory

struct OnboardingMultipleImagesView: View {
    
    @StateObject var model: OnboardingMultipleImagesViewModel
    @State var showImagePicker = false
    @State var errorMessage: String?
    
    @State var showDeleteImageDialog = false
    @State var deleteImageIndex: Int?
    
    var nextAction: (() -> ())?
    func onNextAction(_ action: (() -> ())?) -> Self {
        var copy = self
        copy.nextAction = action
        return copy
    }
    
    var body: some View {
        VStack(spacing: 12) {
            VStack(spacing: 16) {
                Text("더 많은 사진으로\n어필해 보세요")
                    .pretendardTitle1()
                    .multilineTextAlignment(.center)
                
                Text("사진이 많을수록 더 많은 관심을 받을 수 있어요")
                    .pretendardBody()
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 20)
            
            VStack(spacing: 24) {
                
                if model.fetchingInitialData == false {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                        ForEach(0..<6, id: \.self) { index in
                            PhotoUploadCell(
                                image: model.images.count > index ? model.images[index] : nil,
                                isMainPhoto: index == 0,
                                isEnabled: index == model.images.count,
                                onTap: {
                                    withAnimation {
                                        errorMessage = nil
                                    }
                                    if index == model.images.count {
                                        showImagePicker = true
                                    }
                                },
                                onDelete: model.images.count > index ? {
                                    deleteImageIndex = index
                                    showDeleteImageDialog = true
                                } : nil
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                }
                
                VStack(spacing: 12) {
                    BenefitRow(
                        icon: "heart.fill",
                        title: "더 많은 좋아요",
                        description: "사진이 많을수록 5배 더 많은 관심을 받아요"
                    )
                    
                    BenefitRow(
                        icon: "eye.fill",
                        title: "프로필 조회수 증가",
                        description: "다양한 모습으로 더 많은 사람들이 관심을 가져요"
                    )
                    
                    BenefitRow(
                        icon: "message.fill",
                        title: "대화 시작점 제공",
                        description: "여러 사진이 자연스러운 대화의 소재가 되어요"
                    )
                }
                .padding(.horizontal, 24)
            }
            
            Spacer()
            
            VStack(spacing: 16) {
                
                Button {
                    nextAction?()
                } label: {
                    HStack {
                        Text("계속하기")
                            .pretendardBody(.bold)
                            .foregroundColor(.white)
                        
                        if model.images.count > 1 {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.accentColor)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 24)
                
                if let errorMessage {
                    Text(errorMessage)
                        .pretendardCaption()
                        .foregroundColor(.red)
                }
                
                if model.images.count < 3 {
                    Text("최소 3장의 사진을 업로드하는 것을 추천해요")
                        .pretendardCaption()
                        .foregroundColor(.orange)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.bottom, 32)
            .animation(.default, value: model.images.count)
        }
        .modifier(BackgroundModifier())
        .onAppear {
            Task {
                try await model.fetchInitialImages()
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker()
                .onComplete { uiImage in
                    Task {
                        do {
                            withAnimation {
                                errorMessage = nil
                            }
                            try await model.addPhoto(uiImage)
                        } catch AppError.custom(let message, code: _) {
                            withAnimation {
                                errorMessage = message
                            }
                        }
                    }
                }
        }
        .loading(model.loading)
        .dialog(
            message: "이미지를 삭제하시겠습니까?",
            primaryButtonText: "삭제",
            secondaryButtonText: "아니요",
            primaryAction: {
                Task {
                    do {
                        try await model.deletePhoto(at: deleteImageIndex ?? 0)
                    } catch AppError.custom(let message, code: _) {
                        withAnimation {
                            errorMessage = message
                        }
                    }
                }
            },
            isPresented: $showDeleteImageDialog)
    }
}

struct PhotoUploadCell: View {
    let image: UIImage?
    let isMainPhoto: Bool
    let isEnabled: Bool
    let onTap: () -> Void
    let onDelete: (() -> Void)?
    
    var body: some View {
        Button(action: isEnabled ? onTap : {}) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.gray)
                    .frame(height: 120)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .opacity(!isEnabled ? 1.0 : 0.3)
                
                if let image = image {
                    
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.clear)
                        .background {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 120)
                                .clipped()
                                .cornerRadius(12)
                                .overlay(
                                    VStack {
                                        HStack {
                                            if isMainPhoto {
                                                Text("대표")
                                                    .pretendardCaption()
                                                    .foregroundColor(.white)
                                                    .padding(.horizontal, 8)
                                                    .padding(.vertical, 4)
                                                    .background(Color.blue)
                                                    .cornerRadius(6)
                                            }
                                            
                                            Spacer()
                                        }
                                        .padding(8)
                                        Spacer()
                                    }
                                )
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    VStack(spacing: 8) {
                        Image(systemName: isEnabled ? "plus.circle.fill" : "plus.circle")
                            .font(.title2)
                            .foregroundColor(isEnabled ? .primary : .secondary)
                        
                        if isMainPhoto {
                            Text("대표 사진")
                                .pretendardCaption()
                                .foregroundColor(isEnabled ? .primary : .secondary)
                        } else {
                            Text(isEnabled ? "사진 추가" : "순서대로 추가")
                                .pretendardCaption()
                                .foregroundColor(isEnabled ? .primary : .secondary)
                        }
                    }
                }
            }
        }
        .disabled(!isEnabled)
        .overlay(alignment: .topTrailing) {
            if let onDelete = onDelete {
                Button(action: onDelete) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                }
                .padding(4)
            }
        }
    }
}

struct BenefitRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .pretendardBody(.bold)
                
                Text(description)
                    .pretendardCaption()
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

#if DEBUG
#Preview {
    OnboardingMultipleImagesView(model: .init())
//        .preferredColorScheme(.dark)
}
#endif
