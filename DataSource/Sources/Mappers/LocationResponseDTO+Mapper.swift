import Foundation
import Domain

extension LocationResponseDTO {
    func toDomainEntity() -> LocationEntity? {
        guard let createdAt = dateFormatter.date(from: self.createdAt),
              let updatedAt = dateFormatter.date(from: self.updatedAt) else {
            return nil
        }
        
        return LocationEntity(
            id: self.id,
            latitude: self.latitude,
            longitude: self.longitude,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}