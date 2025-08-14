import Foundation

public struct UserEntitiy {
    public let id: String
    public let nickname: String
    public let email: String?
    public let profileImage: ImageEntity?
    public let images: [ImageEntity]
    public let mbti: MBTIEntity?
    public let qnas: [QnAEntity]
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(id: String, nickname: String, email: String?, profileImage: ImageEntity?, images: [ImageEntity], mbti: MBTIEntity?, qnas: [QnAEntity], createdAt: Date, updatedAt: Date) {
        self.id = id
        self.nickname = nickname
        self.email = email
        self.profileImage = profileImage
        self.images = images
        self.mbti = mbti
        self.qnas = qnas
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
