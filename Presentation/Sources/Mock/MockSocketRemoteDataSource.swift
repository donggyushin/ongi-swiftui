//
//  MockSocketRemoteDataSource.swift
//  Presentation
//
//  Created by 신동규 on 8/23/25.
//

import Foundation
import Combine
import Domain

public class MockSocketRemoteDataSource: PSocketRemoteDataSource {
    private let connectionSubject = CurrentValueSubject<Bool, Never>(false)
    private var mockIsConnected = false
    private var eventListeners: [String: Any] = [:]
    
    public init() {}
    
    public func connect() {
        mockIsConnected = true
        connectionSubject.send(true)
        print("[Mock] Socket connected")
    }
    
    public func disconnect() {
        mockIsConnected = false
        connectionSubject.send(false)
        print("[Mock] Socket disconnected")
    }
    
    public func emit(event: String, data: String) {
        print("[Mock] Emitted event '\(event)' with string data: \(data)")
    }
    
    public func emit(event: String, data: [String: Any]) {
        print("[Mock] Emitted event '\(event)' with data: \(data)")
    }
    
    public func listen<T: Codable>(event: String, type: T.Type) -> AnyPublisher<T, Never> {
        print("[Mock] Listening for event '\(event)' with type \(type)")
        
        return PassthroughSubject<T, Never>()
            .eraseToAnyPublisher()
    }
    
    public func listenForConnection() -> AnyPublisher<Bool, Never> {
        return connectionSubject.eraseToAnyPublisher()
    }
    
    public var isConnected: Bool {
        return mockIsConnected
    }
    
    public func simulateEvent<T: Codable>(_ event: String, with data: T) {
        print("[Mock] Simulating event '\(event)' with data: \(data)")
    }
    
    public func simulateConnectionChange(isConnected: Bool) {
        mockIsConnected = isConnected
        connectionSubject.send(isConnected)
        print("[Mock] Connection status changed to: \(isConnected)")
    }
}
