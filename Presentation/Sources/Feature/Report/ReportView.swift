//
//  ReportView.swift
//  Presentation
//
//  Created by 신동규 on 8/28/25.
//

import SwiftUI

struct ReportView: View {
    
    @StateObject var model: ReportViewModel
    @FocusState private var isTextFieldFocused: Bool
    
    @State private var presentFailReportDialog = false
    
    init(model: ReportViewModel) {
        _model = .init(wrappedValue: model)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("신고 사유를 작성해주세요")
                    .pretendardTitle3()
                    .foregroundColor(.primary)
                
                Text("부적절한 내용이나 행동에 대해 구체적으로 작성해주세요")
                    .pretendardCallout()
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .trailing, spacing: 12) {
                ZStack(alignment: .topLeading) {
                    if model.content.isEmpty && !isTextFieldFocused {
                        Text("신고 내용을 입력해주세요...")
                            .pretendardBody()
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                    }
                    
                    TextEditor(text: $model.content)
                        .pretendardBody()
                        .focused($isTextFieldFocused)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 12)
                        .background(Color.clear)
                        .scrollContentBackground(.hidden)
                        .onChange(of: model.content) { _, _ in
                            updateButtonState()
                        }
                }
                .frame(minHeight: 120)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isTextFieldFocused ? Color.accentColor : Color.clear, lineWidth: 2)
                        )
                )
                
                HStack {
                    Text("\(model.minTextLength)자 이상 \(model.maxTextLength)자 이하")
                        .pretendardCaption()
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(model.content.count)/\(model.maxTextLength)")
                        .pretendardCaption()
                        .foregroundColor(model.content.count > model.maxTextLength ? .red : .secondary)
                }
            }
            
            Spacer()
            
            Button {
                Task {
                    do {
                        try await model.report()
                        navigationManager?.pop()
                    } catch {
                        presentFailReportDialog = true
                    }
                }
            } label: {
                AppButton(text: "신고하기", disabled: !model.buttonEnabled || model.loading)
            }
            .disabled(!model.buttonEnabled || model.loading)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .navigationTitle("신고하기")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("취소") {
                    navigationManager?.pop()
                }
                .pretendardBody()
            }
        }
        .loading(model.loading)
        .dialog(message: "신고에 실패하였습니다. 이미 신고한 유저일 수 있습니다.", isPresented: $presentFailReportDialog)
    }
    
    private func updateButtonState() {
        model.buttonEnabled = model.content.count >= model.minTextLength &&
                            model.content.count <= model.maxTextLength
    }
}

#Preview {
    NavigationView {
        ReportView(model: .init(targetUserId: ""))
    }
    .preferredColorScheme(.dark)
}
