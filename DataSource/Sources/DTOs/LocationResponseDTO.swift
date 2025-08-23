import Foundation

struct LocationResponseDTO: Codable {
    let id: String
    let latitude: Float
    let longitude: Float
    let createdAt: String
    let updatedAt: String
}