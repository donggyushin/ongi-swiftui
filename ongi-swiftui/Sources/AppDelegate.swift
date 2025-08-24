//
//  AppDelegate.swift
//  ongi-swiftui
//
//  Created by 신동규 on 8/24/25.
//

import SwiftUI
import Firebase
import FirebaseMessaging
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    
    // APNS 토큰 등록을 위한 설정
    UNUserNotificationCenter.current().delegate = self
    Messaging.messaging().delegate = self
    
    // 원격 푸시 알림 등록
    application.registerForRemoteNotifications()
    
    return true
  }
  
  // APNS 토큰 등록 성공
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
  }
  
  // APNS 토큰 등록 실패
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("APNS token registration failed: \(error)")
  }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
  // 앱이 foreground에 있을 때 알림 처리
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                            willPresent notification: UNNotification,
                            withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.banner, .badge, .sound])
  }
  
  // 사용자가 알림을 탭했을 때
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                            didReceive response: UNNotificationResponse,
                            withCompletionHandler completionHandler: @escaping () -> Void) {
    completionHandler()
  }
}

// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
  // FCM 토큰 새로고침
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    if let token = fcmToken {
      print("FCM registration token: \(token)")
      // 서버에 토큰 업데이트 (필요시)
    }
  }
}
