import Factory
import Domain
import DataSource
import Foundation

// MARK: - Dependency Container Extensions
// Following Factory's Composition Root pattern, this is where all dependencies are wired together

// MARK: - DataSource Layer Dependencies
extension Container {
    
    // MARK: Socket DataSource
    var socketRemoteDataSource: Factory<PSocketRemoteDataSource> {
        self {
            SocketRemoteDataSource(url: URL(string: ongiExpressUrl)!)
        }
        .singleton
    }
    
    // MARK: Repositories
    var jwtRepository: Factory<PJWTRepository> {
        self { 
            JWTRepository.shared
        }
        .singleton
    }
    
    var profileRepository: Factory<PProfileRepository> {
        self {
            ProfileRepository.shared
        }
        .singleton
    }
    
    var authRepository: Factory<PAuthRepository> {
        self {
            AuthRepository()
        }
        .singleton
    }
    
    var qnaRepository: Factory<PQnARepository> {
        self {
            QnARepository()
        }
        .singleton
    }
    
    var verificationRepository: Factory<PVerificationRepository> {
        self {
            VerificationRepository()
        }
        .singleton
    }
    
    var connectionRepository: Factory<PConnectionRepository> {
        self {
            ConnectionRepository()
        }
        .singleton
    }
    
    var chatRepository: Factory<PChatRepository> {
        self {
            ChatRepository()
        }
        .singleton
    }
    
    var realTimeChatRepository: Factory<PRealTimeChatRepository> {
        self {
            RealTimeChatRepository(socketRemoteDataSource: self.socketRemoteDataSource())
        }
        .unique
        // Repository는 싱글턴이 아님 - 필요할 때마다 새 인스턴스 생성
        // Socket 연결은 내부적으로 싱글턴 SocketRemoteDataSource를 공유
    }
    
    var reportRepository: Factory<PReportRepository> {
        self {
            ReportRepository()
        }
        .singleton
    }
    
    var notificationsRepository: Factory<PNotificationsRepository> {
        self {
            NotificationsRepository()
        }
        .singleton
    }
}

// MARK: - Use Case Layer Dependencies
extension Container {
    
    public var profileUseCase: Factory<ProfileUseCase> {
        self {
            ProfileUseCase(
                jwtRepository: self.jwtRepository(),
                profileRepository: self.profileRepository(),
                connectionRepository: self.connectionRepository()
            )
        }
        .singleton
    }
    
    var authUseCase: Factory<AuthUseCase> {
        self {
            AuthUseCase(
                authRepository: self.authRepository(),
                jwtRepository: self.jwtRepository(),
                verificationRepository: self.verificationRepository()
            )
        }
        .singleton
    }
    
    var qnaUseCase: Factory<QNAUseCase> {
        self {
            QNAUseCase(
                profileRepository: self.profileRepository(),
                qnaRepository: self.qnaRepository()
            )
        }
        .singleton
    }
    
    var connectionUseCase: Factory<ConnectionUseCase> {
        self {
            ConnectionUseCase(connectionRepository: self.connectionRepository())
        }
        .singleton
    }
    
    var chatUseCase: Factory<ChatUseCase> {
        self {
            ChatUseCase(chatRepository: self.chatRepository())
        }
        .singleton
    }
    
    var reportUseCase: Factory<ReportUseCase> {
        self {
            ReportUseCase(reportRepository: self.reportRepository())
        }
        .singleton
    }
    
    var notificationsUseCase: Factory<NotificationsUseCase> {
        self {
            NotificationsUseCase(notificationsRepository: self.notificationsRepository())
        }
        .singleton
    }
}

extension Container {
    public var contentViewModel: Factory<ContentViewModel> {
        self {
            .init()
        }
        .singleton
    }
}
