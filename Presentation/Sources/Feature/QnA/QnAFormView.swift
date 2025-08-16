//
//  QnAFormView.swift
//  Presentation
//
//  Created by 신동규 on 8/16/25.
//

import SwiftUI
import Domain

public struct QnAFormView: View {
    
    @StateObject var model: QnAFormViewModel
    @State var errorMessage: String?
    @Environment(\.dismiss) private var dismiss
    
    var complete: ((QnAEntity) -> ())?
    public func onComplete(_ action: ((QnAEntity) -> ())?) -> Self {
        var copy = self
        copy.complete = action
        return copy
    }
    
    public init(model: QnAFormViewModel) {
        _model = .init(wrappedValue: model)
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                if let errorMessage {
                    Text(errorMessage)
                        .pretendardCaption()
                        .foregroundStyle(.red)
                }
                
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
                    Task {
                        do {
                            let qna = try await model.registerQnA()
                            complete?(qna)
                            dismiss()
                        } catch AppError.custom(let message, code: _) {
                            withAnimation {
                                errorMessage = message
                            }
                        }
                    }
                }
                .disabled(!model.isValidForm)
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
            HStack {
                Text("질문")
                    .pretendardHeadline(.semiBold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(model.question.count)/8자 이상")
                    .pretendardCaption(.regular)
                    .foregroundColor(model.question.count >= 8 ? .green : .gray)
            }
            
            TextField("질문을 입력해주세요", text: $model.question, axis: .vertical)
                .pretendardBody(.regular)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(model.question.count < 8 && !model.question.isEmpty ? Color.red : Color.clear, lineWidth: 1)
                        )
                )
                .lineLimit(3...6)
        }
    }
    
    private var answerInputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("답변")
                    .pretendardHeadline(.semiBold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(model.answer.count)/60자 이상")
                    .pretendardCaption(.regular)
                    .foregroundColor(model.answer.count >= 60 ? .green : .gray)
            }
            
            TextField(model.placeholder.isEmpty ? "답변을 입력해주세요" : model.placeholder, 
                     text: $model.answer, axis: .vertical)
                .pretendardBody(.regular)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(model.answer.count < 60 && !model.answer.isEmpty ? Color.red : Color.clear, lineWidth: 1)
                        )
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
