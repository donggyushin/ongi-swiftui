//
//  AppDelegate.swift
//  ongi-swiftui
//
//  Created by 신동규 on 8/24/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    // GoogleService-Info.plist 파일 경로 확인
    if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") {
      print("✅ Found GoogleService-Info.plist at: \(path)")
    } else {
      print("❌ GoogleService-Info.plist not found in bundle")
    }
    
    // Firebase 초기화는 GoogleUtilities 링킹 문제 해결 후 추가 예정
//     FirebaseApp.configure()
      
    return true
  }
}
