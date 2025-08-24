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
                    do {
                        print("dg: 1")
                        try await UNUserNotificationCenter.current().requestAuthorization()
                        print("dg: 2")
                    } catch {
                        print("dg: \(error)")
                    }
                    
                }
                
                Messaging.messaging().token { token, error in
                    print("dg: 3")
                    if let error = error {
                        print("dg: Error fetching FCM registration token: \(error)")
                    } else if let token = token {
                        print("dg: FCM registration token: \(token)")
                        // 서버에 토큰 전송
                        Task {
                            do {
                                try await self.profileUseCase.updateFCM(fcmToken: token)
                            } catch {
                                print("dg: \(error)")
                            }
                            
                        }
                    }
                }
                
            }
            .store(in: &cancellables)
    }
}
