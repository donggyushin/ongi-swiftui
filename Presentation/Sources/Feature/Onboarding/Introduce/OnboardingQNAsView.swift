//
//  OnboardingQNAsView.swift
//  Presentation
//
//  Created by 신동규 on 8/16/25.
//

import SwiftUI
import Domain

struct OnboardingQNAsView: View {
    
    @StateObject var model: OnboardingQNAsViewModel
    
    @State var deleteItemIndex: Int?
    @State var showDeleteDialog = false
    
    var addNewQnA: (() -> ())?
    func onAddNewQnA(_ action: (() -> ())?) -> Self {
        var copy = self
        copy.addNewQnA = action
        return copy
    }
    
    var editQnA: ((QnAEntity) -> ())?
    func onEditQnA(_ action: ((QnAEntity) -> ())?) -> Self {
        var copy = self
        copy.editQnA = action
        return copy
    }
    
    var complete: (() -> ())?
    func onComplete(_ action: (() -> ())?) -> Self {
        var copy = self
        copy.complete = action
        return copy
    }
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 12) {
                Text("나를 소개하는 Q&A")
                    .pretendardTitle1()
                    .foregroundColor(.primary)
                
                Text("질문과 답변으로 나를 더 자세히 표현해보세요")
                    .pretendardBody()
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 40)
            
            if model.fetchingInitialData {
                Spacer()
                ProgressView()
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(Array(model.qnas.enumerated()), id: \.offset) { index, qna in
                            QnAItemView(
                                qna: qna,
                                onDelete: {
                                    deleteItemIndex = index
                                    showDeleteDialog = true
                                }
                            )
                            .onTapGesture {
                                editQnA?(qna)
                            }
                        }
                        
                        if model.isEnoughQNAs == false {
                            Button {
                                addNewQnA?()
                            } label: {
                                VStack(alignment: .leading, spacing: 12) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack(spacing: 8) {
                                            Text("새로운 Q&A 추가")
                                                .pretendardTitle3()
                                                .foregroundColor(.primary)
                                            
                                            Spacer()
                                        }
                                        
                                        Text("질문과 답변을 작성해보세요")
                                            .pretendardBody()
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.gray.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                )
                                .overlay(alignment: .topTrailing) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(.accentColor)
                                        .padding(16)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                Button {
                    complete?()
                } label: {
                    AppButton(text: "다음", disabled: model.qnas.isEmpty)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 20)
                .padding(.bottom, 34)
            }
        }
        .modifier(BackgroundModifier())
        .loading(model.loading)
        .onAppear {
            Task {
                try await model.fetchInitialData()
            }
        }
        .dialog(
            title: "되돌릴 수 없어요",
            message: "정말 질문을 삭제하시겠습니까?",
            primaryButtonText: "삭제",
            secondaryButtonText: "취소",
            primaryAction: {
                Task {
                    try await model.deleteQNA(at: deleteItemIndex ?? 0)
                }
            },
            isPresented: $showDeleteDialog
        )
    }
}

struct QnAItemView: View {
    let qna: QnAEntity
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Q. \(qna.question)")
                    .pretendardTitle3()
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text("A. \(qna.answer)")
                    .pretendardBody()
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .overlay(alignment: .topTrailing) {
                Button {
                    onDelete()
                } label: {
                    Image(systemName: "xmark")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                        .background(Circle().fill(Color.red))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

#Preview {
    OnboardingQNAsView(model: .init())
}
