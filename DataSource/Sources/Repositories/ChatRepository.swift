//
//  ChatRepository.swift
//  DataSource
//
//  Created by 신동규 on 8/22/25.
//

import Domain

public final class ChatRepository: PChatRepository {
    let chatRemoteDataStore = ChatRemoteDataSource()
    
    public init() { }
    
    public func getChats() async throws -> [ChatEntity] {
        return try await chatRemoteDataStore.getChats()
    }
}
