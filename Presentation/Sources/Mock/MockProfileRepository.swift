//
//  MockProfileRepository.swift
//  Presentation
//
//  Created by 신동규 on 8/14/25.
//

import Domain
import Foundation

final class MockProfileRepository: PProfileRepository {
    
    var myProfile: ProfileEntitiy {
        .init(
            id: "me",
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
            introduction: "I love reading books and learning new technologies. It helps me grow both personally and professionally.",
            isNew: false,
            isLikedByMe: true,
            createdAt: .init(),
            updatedAt: .init()
        )
    }
    
    // 내 프로필 상세 페이지 케이스를 확인하고 싶으면 myProfile 과 id를 동일하게 맞추면 됨.
    var profile1: ProfileEntitiy {
        .init(
            id: "me",
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
            introduction: "I love reading books and learning new technologies. It helps me grow both personally and professionally.",
            isNew: true,
            isLikedByMe: false,
            createdAt: .init(),
            updatedAt: .init()
        )
    }
    
    var profile2: ProfileEntitiy {
        .init(
            id: "id2",
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
            introduction: nil,
            isNew: false,
            isLikedByMe: true,
            createdAt: .init(),
            updatedAt: .init()
        )
    }
    
    
    
    init() { }
    
    func getMe(accessToken: String) async throws -> ProfileEntitiy {
        try await Task.sleep(for: .seconds(1))
        return myProfile
    }
    
    func profileImageUpload(imageData: Data) async throws -> ProfileEntitiy {
        try await Task.sleep(for: .seconds(1))
        throw AppError.custom("이미지의 용량이 너무 큽니다.", code: nil)
    }
    
    func uploadImage(imageData: Data) async throws -> ProfileEntitiy {
        try await Task.sleep(for: .seconds(1))
        throw AppError.custom("이미지의 용량이 너무 큽니다.", code: nil)
    }
    
    func updateGender(gender: GenderEntity) async throws -> ProfileEntitiy {
        try await Task.sleep(for: .seconds(1))
        return profile1
    }
    
    func updatePhysicalInfo(height: CGFloat, weight: CGFloat) async throws -> ProfileEntitiy {
        try await Task.sleep(for: .seconds(1))
        throw AppError.custom("잘못된 체중 입력", code: nil)
    }
    
    func deleteImage(publicId: String) async throws -> ProfileEntitiy {
        try await Task.sleep(for: .seconds(1))
        return profile2
    }
    
    func updateNickname(nickname: String) async throws -> ProfileEntitiy {
        try await Task.sleep(for: .seconds(1))
        throw AppError.custom("Test Error Occured", code: nil)
    }
    
    func updateMBTI(mbti: MBTIEntity) async throws -> ProfileEntitiy {
        try await Task.sleep(for: .seconds(1))
        throw AppError.custom("Test Error Occured", code: nil)
    }
    
    func updateIntroduce(introduce: String) async throws -> ProfileEntitiy {
        try await Task.sleep(for: .seconds(1))
        throw AppError.custom("Test Error Occured", code: nil)
    }
    
    func addQNA(question: String, answer: String) async throws -> ProfileEntitiy {
        try await Task.sleep(for: .seconds(1))
        return profile1
    }
    
    func deleteQNA(qnaId: String) async throws -> ProfileEntitiy {
        try await Task.sleep(for: .seconds(1))
        return profile2
    }
    
    func updateQNA(qnaId: String, answer: String) async throws -> ProfileEntitiy {
        try await Task.sleep(for: .seconds(1))
        return profile1
    }
    
    func search(profileId: String) async throws -> ProfileEntitiy {
        return profile1
    }
}
