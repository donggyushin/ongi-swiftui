//
//  MailComposeView.swift
//  ongi-swiftui
//
//  Created by 신동규 on 8/22/25.
//

import MessageUI
import SwiftUI

struct MailComposeView: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    
    let recipients: [String]
    let subject: String
    let messageBody: String
    
    init(recipients: [String], subject: String, messageBody: String) {
        self.recipients = recipients
        self.subject = subject
        self.messageBody = messageBody
    }
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailCompose = MFMailComposeViewController()
        mailCompose.mailComposeDelegate = context.coordinator
        mailCompose.setToRecipients(["donggyu9410@gmail.com"])
        mailCompose.setSubject("온기 앱 피드백")
        mailCompose.setMessageBody("안녕하세요,\n\n온기 앱에 대한 피드백이나 문의사항을 적어주세요.\n\n", isHTML: false)
        return mailCompose
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let parent: MailComposeView
        
        init(_ parent: MailComposeView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            parent.dismiss()
        }
    }
}
