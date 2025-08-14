import Foundation
import Domain

extension QnAResponseDTO {
    func toDomainEntity() -> QnAEntity? {
        
        guard let createdAt = dateFormatter.date(from: self.createdAt),
              let updatedAt = dateFormatter.date(from: self.updatedAt) else {
            return nil
        }
        
        return QnAEntity(
            id: self.id,
            question: self.question,
            answer: self.answer,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Array where Element == QnAResponseDTO {
    func toDomainEntities() -> [QnAEntity] {
        return self.compactMap { $0.toDomainEntity() }
    }
}
