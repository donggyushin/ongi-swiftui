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
    guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") else {
      print("GoogleService-Info.plist not found in bundle")
      return true
    }
    print("Found GoogleService-Info.plist at: \(path)")
    
    FirebaseApp.configure()
      
    return true
  }
}
