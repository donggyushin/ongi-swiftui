//
//  AppDelegate.swift
//  ongi-swiftui
//
//  Created by 신동규 on 8/24/25.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    // Firebase 초기화는 GoogleUtilities 링킹 문제 해결 후 추가 예정
    FirebaseApp.configure()

    return true
  }
}
