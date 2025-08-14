import Foundation
import Domain

extension ProfileResponseDTO {
    func toDomainEntity() -> ProfileEntitiy? {
        let dateFormatter = ISO8601DateFormatter()
        
        guard let createdAt = dateFormatter.date(from: self.createdAt),
              let updatedAt = dateFormatter.date(from: self.updatedAt) else {
            return nil
        }
        
        let profileImageEntity = self.profileImage?.toDomainEntity()
        let imageEntities = self.images.toDomainEntities()
        let qnaEntities = self.qnas.toDomainEntities()
        
        let mbtiEntity: MBTIEntity?
        if let mbtiString = self.mbti {
            switch mbtiString.uppercased() {
            case "INTJ": mbtiEntity = .intj
            case "INTP": mbtiEntity = .intp
            case "ENTJ": mbtiEntity = .entj
            case "ENTP": mbtiEntity = .entp
            case "INFJ": mbtiEntity = .infj
            case "INFP": mbtiEntity = .infp
            case "ENFJ": mbtiEntity = .enfj
            case "ENFP": mbtiEntity = .enfp
            case "ISTJ": mbtiEntity = .istj
            case "ISFJ": mbtiEntity = .isfj
            case "ESTJ": mbtiEntity = .estj
            case "ESFJ": mbtiEntity = .esfj
            case "ISTP": mbtiEntity = .istp
            case "ISFP": mbtiEntity = .isfp
            case "ESTP": mbtiEntity = .estp
            case "ESFP": mbtiEntity = .esfp
            default: mbtiEntity = nil
            }
        } else {
            mbtiEntity = nil
        }
        
        return ProfileEntitiy(
            id: self.id,
            nickname: self.nickname,
            email: self.email,
            profileImage: profileImageEntity,
            images: imageEntities,
            mbti: mbtiEntity,
            qnas: qnaEntities,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
