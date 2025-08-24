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
                    if let token = token {
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
