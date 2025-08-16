//
//  QNAUseCase.swift
//  Domain
//
//  Created by 신동규 on 8/16/25.
//

public final class QNAUseCase {
    let profileRepository: PProfileRepository
    
    public init(profileRepository: PProfileRepository) {
        self.profileRepository = profileRepository
    }
    
    public func add(_ entitiy: QnAEntity) async throws -> ProfileEntitiy {
        try await profileRepository.addQNA(question: entitiy.question, answer: entitiy.answer)
    }
    
    public func update(_ entitiy: QnAEntity) async throws -> ProfileEntitiy {
        try await profileRepository.updateQNA(qnaId: entitiy.id, answer: entitiy.answer)
    }
    
    public func delete(qnaId: String) async throws -> ProfileEntitiy {
        try await profileRepository.deleteQNA(qnaId: qnaId)
    }
}
