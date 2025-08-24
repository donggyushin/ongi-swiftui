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
                    try await UNUserNotificationCenter.current().requestAuthorization()
                }
                
                Messaging.messaging().token { token, error in
                    if let error = error {
                        print("Error fetching FCM registration token: \(error)")
                    } else if let token = token {
                        print("FCM registration token: \(token)")
                        // 서버에 토큰 전송
                        Task {
                            try await self.profileUseCase.updateFCM(fcmToken: token)
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
}
