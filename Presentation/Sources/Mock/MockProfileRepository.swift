//
//  MockProfileRepository.swift
//  Presentation
//
//  Created by 신동규 on 8/14/25.
//

import Domain
import Foundation

final class MockProfileRepository: PProfileRepository {
    
    var profile1: ProfileEntitiy {
        .init(
            id: "id",
            nickname: "달콤한레이지",
            email: "donggyu9410@gmail.com",
            profileImage: .init(url: .init(string: "https://res.cloudinary.com/blog-naver-com-donggyu-00/image/upload/v1755269648/profile-images/profile_nickname_test_0023_1755269630832.jpg")!, publicId: "profile-images/profile_nickname_test_0023_1755242951793"),
            images: [
                .init(url: .init(string: "https://res.cloudinary.com/blog-naver-com-donggyu-00/image/upload/v1755269648/profile-images/profile_nickname_test_0023_1755269630832.jpg")!, publicId: "profile-images/profile_nickname_test_0023_1755242951793"),
                .init(url: .init(string: "https://res.cloudinary.com/blog-naver-com-donggyu-00/image/upload/v1755269702/profile-images/profile_gallery_nickname_test_0023_1755269701280.jpg")!, publicId: "profile-images/profile_nickname_test_0023_1755242951793")
            ],
            mbti: .infj,
            qnas: [
                .init(id: "", question: "What is your favorite hobby?", answer: "I love reading books and learning new technologies. It helps me grow both personally and professionally.", createdAt: .init(), updatedAt: .init())
            ],
            gender: .female,
            height: 151,
            weight: 53,
            bodyType: .chubby,
            selfIntroduce: "I love reading books and learning new technologies. It helps me grow both personally and professionally.",
            createdAt: .init(),
            updatedAt: .init()
        )
    }
    
    var profile2: ProfileEntitiy {
        .init(
            id: "id",
            nickname: "달콤한레이지",
            email: nil,
            profileImage: nil,
            images: [],
            mbti: nil,
            qnas: [],
            gender: nil,
            height: nil,
            weight: nil,
            bodyType: nil,
            selfIntroduce: nil,
            createdAt: .init(),
            updatedAt: .init()
        )
    }
    
    
    
    init() { }
    
    func getMe(accessToken: String) async throws -> ProfileEntitiy {
        profile1
    }
    
    func profileImageUpload(imageData: Data) async throws -> ProfileEntitiy {
        profile1
    }
    
    func uploadImage(imageData: Data) async throws -> ProfileEntitiy {
        profile1
    }
}
