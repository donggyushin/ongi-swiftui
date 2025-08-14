import Foundation
import Domain

extension ImageResponseDTO {
    func toDomainEntity() -> ImageEntity? {
        guard let url = URL(string: self.url) else {
            return nil
        }
        
        return ImageEntity(
            url: url,
            publicId: self.publicId
        )
    }
}

extension Array where Element == ImageResponseDTO {
    func toDomainEntities() -> [ImageEntity] {
        return self.compactMap { $0.toDomainEntity() }
    }
}