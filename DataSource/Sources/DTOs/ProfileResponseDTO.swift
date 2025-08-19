import Foundation

struct ProfileResponseDTO: Codable {
    let id: String
    let nickname: String
    let email: String?
    let profileImage: ImageResponseDTO?
    let images: [ImageResponseDTO]
    let mbti: String?
    let qnas: [QnAResponseDTO]
    let gender: String?
    let height: Double?
    let weight: Double?
    let bodyType: String?
    let introduction: String?
    let isNew: Bool?
    let isLikedByMe: Bool?
    let createdAt: String
    let updatedAt: String
}
