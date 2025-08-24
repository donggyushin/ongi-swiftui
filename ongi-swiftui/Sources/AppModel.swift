//
//  AppModel.swift
//  ongi-swiftui
//
//  Created by 신동규 on 8/24/25.
//

import Factory
import FirebaseMessaging
import Domain
import Presentation
import Combine
import UserNotifications

final class AppModel: ObservableObject {
    
    @Injected(\.contentViewModel) private var contentViewModel
    @Injected(\.profileUseCase) private var profileUseCase
    
    @Published private var cancellables = Set<AnyCancellable>()
    
    init() {
        bind()
    }
    
    private func bind() {
        contentViewModel
            .$isLogin
            .filter { $0 }
            .sink { [weak self] _ in
                guard let self else { return }
                Task {
                    try await self.configPushToken()
                }
            }
            .store(in: &cancellables)
    }
    
    private func configPushToken() async throws {
        let _ = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        
        // 1초 후에 FCM 토큰 요청
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        return try await withCheckedThrowingContinuation { continuation in
            Messaging.messaging().token { [weak self] token, error in
                if let token = token {
                    Task { @MainActor in
                        do {
                            try await self?.profileUseCase.updateFCM(fcmToken: token)
                            continuation.resume()
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    }
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
}
