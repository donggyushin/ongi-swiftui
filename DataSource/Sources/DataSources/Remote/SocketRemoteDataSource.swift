import Foundation
import SocketIO
import Combine
import ThirdParty
import Domain

public protocol PSocketRemoteDataSource {
    func connect()
    func disconnect()
    func emit(event: String, data: String)
    func emit(event: String, data: [String: Any])
    func listen<T: Codable>(event: String, type: T.Type) -> AnyPublisher<T, Never>
    func listenForConnection() -> AnyPublisher<Bool, Never>
    var isConnected: Bool { get }
}

public class SocketRemoteDataSource: PSocketRemoteDataSource {
    private let manager: SocketManager
    private let socket: SocketIOClient
    private let connectionSubject = CurrentValueSubject<Bool, Never>(false)
    
    // 이벤트별 Subject들을 관리하는 딕셔너리
    private var eventSubjects: [String: Any] = [:]
    private var eventListeners: Set<String> = []
    
    public init(url: URL, namespace: String = "/") {
        self.manager = SocketManager(socketURL: url, config: [.log(false), .compress])
        self.socket = manager.socket(forNamespace: namespace)
        setupSocketEvents()
    }
    
    private func setupSocketEvents() {
        socket.on(clientEvent: .connect) { [weak self] data, ack in
            print("[Socket] Socket connected")
            self?.connectionSubject.send(true)
        }
        
        socket.on(clientEvent: .disconnect) { [weak self] data, ack in
            print("[Socket] Socket disconnected")
            self?.connectionSubject.send(false)
        }
        
        socket.on(clientEvent: .error) { data, ack in
            print("[Socket] Socket error: \(data)")
        }
        
        socket.on(clientEvent: .reconnect) { [weak self] data, ack in
            print("[Socket] Socket reconnected")
            self?.connectionSubject.send(true)
        }
    }
    
    public func connect() {
        socket.connect()
    }
    
    public func disconnect() {
        socket.disconnect()
        
        // 모든 Subject들 완료 처리 및 정리
        for (event, subject) in eventSubjects {
            if let subject = subject as? PassthroughSubject<Any, Never> {
                subject.send(completion: .finished)
            }
        }
        eventSubjects.removeAll()
        eventListeners.removeAll()
    }
    
    public func emit(event: String, data: String) {
        print("[Socket] event: \(event), data: \(data)")
        socket.emit(event, data)
    }
    
    public func emit(event: String, data: [String: Any]) {
        print("[Socket] event: \(event), data: \(data)")
        socket.emit(event, data)
    }
    
    public func listen<T: Codable>(event: String, type: T.Type) -> AnyPublisher<T, Never> {
        // 이미 등록된 이벤트의 Subject가 있다면 재사용
        if let existingSubject = eventSubjects[event] as? PassthroughSubject<T, Never> {
            return existingSubject.eraseToAnyPublisher()
        }
        
        // 새 Subject 생성
        let subject = PassthroughSubject<T, Never>()
        eventSubjects[event] = subject
        
        // Socket 이벤트 리스너 등록 (중복 방지)
        if !eventListeners.contains(event) {
            eventListeners.insert(event)
            
            socket.on(event) { [weak self] data, ack in
                guard let firstData = data.first else { return }
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: firstData)
                    let decodedData = try JSONDecoder().decode(T.self, from: jsonData)
                    
                    // Subject로 데이터 전송 (여러 번 가능!)
                    if let subject = self?.eventSubjects[event] as? PassthroughSubject<T, Never> {
                        subject.send(decodedData)
                    }
                } catch {
                    print("[Socket] Failed to decode socket data for event \(event): \(error)")
                }
            }
        }
        
        return subject.eraseToAnyPublisher()
    }
    
    public func listenForConnection() -> AnyPublisher<Bool, Never> {
        return connectionSubject.eraseToAnyPublisher()
    }
    
    public var isConnected: Bool {
        return socket.status == .connected
    }
}
