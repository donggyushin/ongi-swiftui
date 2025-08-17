import Foundation

public struct ProfileEntitiy {
    public let id: String
    public var nickname: String
    public var email: String?
    public var profileImage: ImageEntity?
    public var images: [ImageEntity]
    public var mbti: MBTIEntity?
    public var qnas: [QnAEntity]
    public var gender: GenderEntity?
    public var height: CGFloat?
    public var weight: CGFloat?
    public var bodyType: BodyType?
    public var introduction: String?
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(id: String, nickname: String, email: String?, profileImage: ImageEntity?, images: [ImageEntity], mbti: MBTIEntity?, qnas: [QnAEntity], gender: GenderEntity?, height: CGFloat?, weight: CGFloat?, bodyType: BodyType?, introduction: String?, createdAt: Date, updatedAt: Date) {
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
        self.introduction = introduction
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    public var isCompleted: Bool {
        return profileImage != nil &&
        mbti != nil &&
        gender != nil &&
        height != nil &&
        weight != nil &&
        introduction != nil &&
        qnas.isEmpty == false
    }
}
