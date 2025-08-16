//
//  QNAUseCase.swift
//  Domain
//
//  Created by 신동규 on 8/16/25.
//

public final class QNAUseCase {
    let profileRepository: PProfileRepository
    let qnaRepository: PQnARepository
    
    public init(
        profileRepository: PProfileRepository,
        qnaRepository: PQnARepository
    ) {
        self.profileRepository = profileRepository
        self.qnaRepository = qnaRepository
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
    
    public func examples() async throws -> [QnAEntity] {
        try await qnaRepository.getExamples()
    }
}
