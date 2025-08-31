//
//  MessageInputView.swift
//  ongi-swiftui
//
//  Created by 신동규 on 8/30/25.
//

import SwiftUI

struct MessageInputView: View {
    @Binding var text: String
    let onSend: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .pretendardBody()
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .frame(minHeight: 36, maxHeight: 100)
                
                if text.isEmpty {
                    Text("메시지를 입력하세요")
                        .pretendardBody()
                        .foregroundColor(.gray)
                        .padding(.leading, 4)
                        .padding(.top, 8)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
            .background(Color(.systemGray6))
            .cornerRadius(20)
            .fixedSize(horizontal: false, vertical: true)
            
            Button(action: onSend) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title2)
                    .foregroundColor(text.isEmpty ? .gray : .blue)
            }
            .disabled(text.isEmpty)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
}

#if DEBUG
private struct MessageInputViewPreview: View {
    
    @State private var text = ""
    
    var body: some View {
        MessageInputView(text: $text) {
            
        }
    }
}

#Preview {
    MessageInputViewPreview()
}
#endif
