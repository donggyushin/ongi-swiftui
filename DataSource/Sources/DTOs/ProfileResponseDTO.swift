import Foundation

struct ProfileResponseDTO: Codable {
    let id: String
    let nickname: String
    let email: String?
    let profileImage: ImageResponseDTO?
    let images: [ImageResponseDTO]
    let mbti: String?
    let qnas: [QnAResponseDTO]
    let createdAt: String
    let updatedAt: String
}
