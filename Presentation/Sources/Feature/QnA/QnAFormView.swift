//
//  QnAFormView.swift
//  Presentation
//
//  Created by 신동규 on 8/16/25.
//

import SwiftUI

struct QnAFormView: View {
    
    @StateObject var model: QnAFormViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if model.isVisibleExamples {
                    exampleQuestionsSection
                }
                questionInputSection
                answerInputSection
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .navigationTitle("QnA 작성")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("저장") {
                    // TODO: 저장 액션 구현
                }
                .disabled(model.question.isEmpty || model.answer.isEmpty)
            }
        }
        .task {
            try? await model.fetchExamples()
        }
        .modifier(BackgroundModifier())
        .loading(model.loading)
    }
    
    private var exampleQuestionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("예시 질문")
                .pretendardHeadline(.semiBold)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(model.examples, id: \.id) { example in
                    Button(action: {
                        model.selectExample(example)
                    }) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(example.question)
                                .pretendardBody(.medium)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                                .lineLimit(3)
                            
                            Text(example.answer)
                                .pretendardCaption(.regular)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray6))
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    private var questionInputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("질문")
                .pretendardHeadline(.semiBold)
                .foregroundColor(.primary)
            
            TextField("질문을 입력해주세요", text: $model.question, axis: .vertical)
                .pretendardBody(.regular)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )
                .lineLimit(3...6)
        }
    }
    
    private var answerInputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("답변")
                .pretendardHeadline(.semiBold)
                .foregroundColor(.primary)
            
            TextField(model.placeholder.isEmpty ? "답변을 입력해주세요" : model.placeholder, 
                     text: $model.answer, axis: .vertical)
                .pretendardBody(.regular)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )
                .lineLimit(5...10)
        }
    }
}

#if DEBUG
#Preview {
    QnAFormView(model: .init())
}
#endif
