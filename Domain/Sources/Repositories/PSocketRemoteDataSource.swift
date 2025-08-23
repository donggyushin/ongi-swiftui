//
//  PSocketRemoteDataSource.swift
//  Domain
//
//  Created by 신동규 on 8/23/25.
//

import Foundation
import Combine

public protocol PSocketRemoteDataSource {
    func connect()
    func disconnect()
    func emit(event: String, data: String)
    func emit(event: String, data: [String: Any])
    func listen<T: Codable>(event: String, type: T.Type) -> AnyPublisher<T, Never>
    func listenForConnection() -> AnyPublisher<Bool, Never>
    var isConnected: Bool { get }
}
