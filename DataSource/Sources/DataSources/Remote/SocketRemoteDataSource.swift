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
    }
    
    public func emit(event: String, data: String) {
        socket.emit(event, data)
    }
    
    public func emit(event: String, data: [String: Any]) {
        socket.emit(event, data)
    }
    
    public func listen<T: Codable>(event: String, type: T.Type) -> AnyPublisher<T, Never> {
        return Future<T, Never> { [weak self] promise in
            self?.socket.on(event) { data, ack in
                guard let firstData = data.first else { return }
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: firstData)
                    let decodedData = try JSONDecoder().decode(T.self, from: jsonData)
                    promise(.success(decodedData))
                } catch {
                    print("[Socket] Failed to decode socket data for event \(event): \(error)")
                }
            }
        }
        .share()
        .eraseToAnyPublisher()
    }
    
    public func listenForConnection() -> AnyPublisher<Bool, Never> {
        return connectionSubject.eraseToAnyPublisher()
    }
    
    public var isConnected: Bool {
        return socket.status == .connected
    }
}
