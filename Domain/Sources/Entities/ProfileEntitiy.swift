import Foundation

public struct ProfileEntitiy {
    public let id: String
    public let nickname: String
    public let email: String?
    public let profileImage: ImageEntity?
    public let images: [ImageEntity]
    public let mbti: MBTIEntity?
    public let qnas: [QnAEntity]
    public let gender: GenderEntity?
    public let height: CGFloat?
    public let weight: CGFloat?
    public let bodyType: BodyType?
    public let selfIntroduce: String?
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(id: String, nickname: String, email: String?, profileImage: ImageEntity?, images: [ImageEntity], mbti: MBTIEntity?, qnas: [QnAEntity], gender: GenderEntity?, height: CGFloat?, weight: CGFloat?, bodyType: BodyType?, selfIntroduce: String?, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.nickname = nickname
        self.email = email
        self.profileImage = profileImage
        self.images = images
        self.mbti = mbti
        self.qnas = qnas
        self.gender = gender
        self.height = height
        self.weight = weight
        self.bodyType = bodyType
        self.selfIntroduce = selfIntroduce
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    public var isCompleted: Bool {
        return profileImage != nil &&
        mbti != nil &&
        gender != nil &&
        height != nil &&
        weight != nil
    }
}
