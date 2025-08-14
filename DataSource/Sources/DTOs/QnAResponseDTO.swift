import Foundation

struct QnAResponseDTO: Codable {
    let id: String
    let question: String
    let answer: String
    let createdAt: String
    let updatedAt: String
}
