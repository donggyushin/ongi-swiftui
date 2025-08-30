//
//  MockProfileRepository.swift
//  Presentation
//
//  Created by 신동규 on 8/14/25.
//

import Domain
import Foundation

final class MockProfileRepository: PProfileRepository {
    
    // MARK: - Shared Data Store
    private let dataStore = MockDataStore.shared
    
    // MARK: - Mock Data Generator
    private static func randomDate(within days: Int = 30) -> Date {
        let now = Date()
        let randomInterval = TimeInterval.random(in: 0...(TimeInterval(days * 24 * 60 * 60)))
        return now.addingTimeInterval(-randomInterval)
    }
    
    
    
    private static func sampleImageURL(_ index: Int) -> URL {
        URL(string: "https://picsum.photos/400/600?random=\(index)")!
    }
    
    private static func sampleQnAs(count: Int = 2) -> [QnAEntity] {
        let questions = [
            "가장 좋아하는 취미는 무엇인가요?",
            "이상형은 어떤 사람인가요?",
            "여행에서 가장 기억에 남는 곳은?",
            "스트레스 받을 때 어떻게 푸시나요?",
            "인생에서 가장 소중한 것은?",
            "좋아하는 음식은 무엇인가요?"
        ]
        
        let answers = [
            "책 읽기와 새로운 기술 배우기를 정말 좋아해요. 개인적으로나 전문적으로 성장하는 데 도움이 돼요.",
            "서로를 존중하고 함께 성장할 수 있는 사람이 좋아요. 유머 감각도 중요하고요!",
            "제주도에서 본 일출이 정말 잊을 수 없어요. 자연의 아름다움에 감동했어요.",
            "친구들과 맛있는 걸 먹으면서 수다 떨기! 그리고 혼자 음악 들으면서 산책하는 것도 좋아해요.",
            "가족과 친구들이죠. 사랑하는 사람들과의 소중한 시간이 제일 중요해요.",
            "파스타와 한식을 정말 좋아해요. 특히 엄마가 해주시는 김치찌개는 최고예요!"
        ]
        
        return (0..<count).map { index in
            QnAEntity(
                id: "qna_\(index)",
                question: questions[index % questions.count],
                answer: answers[index % answers.count],
                createdAt: Self.randomDate(),
                updatedAt: Self.randomDate()
            )
        }
    }
    
    // MARK: - Profile Data
    var myProfile: ProfileEntitiy {
        .init(
            id: "me",
            nickname: "달콤한레이지",
            email: "donggyu9410@gmail.com",
            profileImage: .init(
                url: URL(string: "https://picsum.photos/400/600?random=999")!,
                publicId: "profile-images/me_profile"
            ),
            images: [
                .init(url: Self.sampleImageURL(999), publicId: "profile-images/me_1"),
                .init(url: Self.sampleImageURL(998), publicId: "profile-images/me_2")
            ],
            mbti: .infj,
            qnas: Self.sampleQnAs(count: 3),
            gender: .female,
            height: 165,
            weight: 55,
            bodyType: .normal,
            location: .init(
                id: "loc_me",
                latitude: 37.5665,
                longitude: 126.9780,
                createdAt: Self.randomDate(within: 30),
                updatedAt: Self.randomDate(within: 7)
            ),
            introduction: "안녕하세요! 새로운 사람들과의 만남을 소중히 여기는 사람입니다. 함께 즐거운 시간을 보내고 싶어요 😊",
            isNew: false,
            isLikedByMe: false,
            createdAt: Self.randomDate(within: 60),
            updatedAt: Self.randomDate(within: 7),
            lastTokenAuthAt: Self.randomDate(within: 7)
        )
    }
    
    var profile1: ProfileEntitiy {
        .init(
            id: "user_001",
            nickname: "커피러버",
            email: "coffee.lover@example.com",
            profileImage: .init(
                url: Self.sampleImageURL(1),
                publicId: "profile-images/user_001_profile"
            ),
            images: [
                .init(url: Self.sampleImageURL(1), publicId: "profile-images/user_001_1"),
                .init(url: Self.sampleImageURL(11), publicId: "profile-images/user_001_2"),
                .init(url: Self.sampleImageURL(21), publicId: "profile-images/user_001_3")
            ],
            mbti: .enfp,
            qnas: Self.sampleQnAs(count: 2),
            gender: .male,
            height: 175,
            weight: 70,
            bodyType: .normal,
            location: .init(
                id: "loc_001",
                latitude: 37.5547,
                longitude: 126.9707,
                createdAt: Self.randomDate(within: 30),
                updatedAt: Self.randomDate(within: 7)
            ),
            introduction: "카페 투어가 취미인 커피 마니아입니다! 맛있는 커피와 함께 좋은 대화 나누고 싶어요 ☕️",
            isNew: true,
            isLikedByMe: false,
            createdAt: Self.randomDate(within: 3),
            updatedAt: Self.randomDate(within: 1),
            lastTokenAuthAt: Self.randomDate(within: 3)
        )
    }
    
    var profile2: ProfileEntitiy {
        .init(
            id: "user_002",
            nickname: "산책하는고양이",
            email: "cat.walker@example.com",
            profileImage: .init(
                url: Self.sampleImageURL(2),
                publicId: "profile-images/user_002_profile"
            ),
            images: [
                .init(url: Self.sampleImageURL(2), publicId: "profile-images/user_002_1"),
                .init(url: Self.sampleImageURL(12), publicId: "profile-images/user_002_2")
            ],
            mbti: .isfp,
            qnas: Self.sampleQnAs(count: 3),
            gender: .female,
            height: 160,
            weight: 48,
            bodyType: .slim,
            location: nil,
            introduction: "고양이 두 마리와 함께 살고 있어요. 조용한 산책과 독서를 좋아하는 내향적인 사람입니다 🐱",
            isNew: false,
            isLikedByMe: true,
            createdAt: Self.randomDate(within: 14),
            updatedAt: Self.randomDate(within: 2),
            lastTokenAuthAt: Self.randomDate(within: 5)
        )
    }
    
    var profile3: ProfileEntitiy {
        .init(
            id: "user_003",
            nickname: "운동하는직장인",
            email: "fitness.worker@example.com",
            profileImage: .init(
                url: Self.sampleImageURL(3),
                publicId: "profile-images/user_003_profile"
            ),
            images: [
                .init(url: Self.sampleImageURL(3), publicId: "profile-images/user_003_1"),
                .init(url: Self.sampleImageURL(13), publicId: "profile-images/user_003_2"),
                .init(url: Self.sampleImageURL(23), publicId: "profile-images/user_003_3")
            ],
            mbti: .estj,
            qnas: Self.sampleQnAs(count: 4),
            gender: .male,
            height: 180,
            weight: 75,
            bodyType: .normal,
            location: .init(
                id: "loc_003",
                latitude: 37.5172,
                longitude: 127.0473,
                createdAt: Self.randomDate(within: 30),
                updatedAt: Self.randomDate(within: 7)
            ),
            introduction: "헬스장에서 운동하는 것이 일상인 직장인이에요. 건강한 라이프스타일을 함께 할 분을 찾고 있어요 💪",
            isNew: true,
            isLikedByMe: false,
            createdAt: Self.randomDate(within: 7),
            updatedAt: Self.randomDate(within: 1),
            lastTokenAuthAt: Self.randomDate(within: 3)
        )
    }
    
    // MARK: - Additional Mock Profiles
    private var allMockProfiles: [ProfileEntitiy] {
        [
            profile1, profile2, profile3,
            createProfile(id: "user_004", nickname: "책벌레", mbti: .intj, gender: .female, isNew: false),
            createProfile(id: "user_005", nickname: "여행러", mbti: .entp, gender: .male, isNew: true),
            createProfile(id: "user_006", nickname: "음악애호가", mbti: .isfj, gender: .female, isNew: false),
            createProfile(id: "user_007", nickname: "요리사", mbti: .esfp, gender: .male, isNew: true),
            createProfile(id: "user_008", nickname: "사진작가", mbti: .infp, gender: .female, isNew: false),
            createProfile(id: "user_009", nickname: "개발자", mbti: .intp, gender: .male, isNew: true),
            createProfile(id: "user_010", nickname: "디자이너", mbti: .enfj, gender: .female, isNew: false)
        ]
    }
    
    private func createProfile(id: String, nickname: String, mbti: MBTIEntity, gender: GenderEntity, isNew: Bool) -> ProfileEntitiy {
        let index = Int(id.suffix(3)) ?? 1
        
        let introductions = [
            "새로운 인연을 만나고 싶어요!",
            "함께 즐거운 시간을 보낼 수 있는 분을 찾고 있어요.",
            "소소한 일상을 공유하며 서로를 알아가고 싶습니다.",
            "진솔한 대화를 나눌 수 있는 사람이면 좋겠어요.",
            "같은 취미를 가진 분과 만나고 싶어요!",
            "서로를 응원해줄 수 있는 관계를 원해요."
        ]
        
        return ProfileEntitiy(
            id: id,
            nickname: nickname,
            email: "\(nickname.lowercased())@example.com",
            profileImage: .init(
                url: Self.sampleImageURL(index),
                publicId: "profile-images/\(id)_profile"
            ),
            images: [
                .init(url: Self.sampleImageURL(index), publicId: "profile-images/\(id)_1"),
                .init(url: Self.sampleImageURL(index + 10), publicId: "profile-images/\(id)_2")
            ],
            mbti: mbti,
            qnas: Self.sampleQnAs(count: Int.random(in: 1...3)),
            gender: gender,
            height: gender == .male ? CGFloat.random(in: 170...185) : CGFloat.random(in: 155...170),
            weight: gender == .male ? CGFloat.random(in: 65...80) : CGFloat.random(in: 45...60),
            bodyType: BodyType.allCases.randomElement()!,
            location: Bool.random() ? .init(
                id: "loc_\(id)",
                latitude: Float.random(in: 37.4...37.7),
                longitude: Float.random(in: 126.8...127.2),
                createdAt: Self.randomDate(within: 30),
                updatedAt: Self.randomDate(within: 7)
            ) : nil,
            introduction: introductions[index % introductions.count],
            isNew: isNew,
            isLikedByMe: Bool.random(),
            createdAt: Self.randomDate(within: 30),
            updatedAt: Self.randomDate(within: 7),
            lastTokenAuthAt: Self.randomDate(within: 14)
        )
    }
    
    init() { }
    
    // MARK: - Helper Methods
    private func simulateNetworkDelay() async throws {
        try await Task.sleep(for: .milliseconds(Int.random(in: 500...1500)))
    }
    
    private func randomError() -> AppError {
        let errors = [
            AppError.custom("네트워크 연결이 불안정합니다.", code: 1001),
            AppError.custom("서버에서 일시적인 오류가 발생했습니다.", code: 1002),
            AppError.custom("요청 처리 중 오류가 발생했습니다.", code: 1003)
        ]
        return errors.randomElement()!
    }
    
    // MARK: - Repository Implementation
    
    func getMe(accessToken: String) async throws -> ProfileEntitiy {
        try await simulateNetworkDelay()
        return myProfile
    }
    
    func profileImageUpload(imageData: Data) async throws -> ProfileEntitiy {
        try await simulateNetworkDelay()
        
        // Simulate different scenarios
        if imageData.count > 5_000_000 { // 5MB
            throw AppError.custom("이미지 용량이 너무 큽니다. (최대 5MB)", code: 413)
        }
        
        if Bool.random() { // 50% chance of success
            var updatedProfile = myProfile
            // Simulate new profile image
            let newImageIndex = Int.random(in: 100...999)
            updatedProfile = ProfileEntitiy(
                id: updatedProfile.id,
                nickname: updatedProfile.nickname,
                email: updatedProfile.email,
                profileImage: .init(
                    url: Self.sampleImageURL(newImageIndex),
                    publicId: "profile-images/\(updatedProfile.id)_\(newImageIndex)"
                ),
                images: updatedProfile.images,
                mbti: updatedProfile.mbti,
                qnas: updatedProfile.qnas,
                gender: updatedProfile.gender,
                height: updatedProfile.height,
                weight: updatedProfile.weight,
                bodyType: updatedProfile.bodyType,
                location: updatedProfile.location,
                introduction: updatedProfile.introduction,
                isNew: updatedProfile.isNew,
                isLikedByMe: updatedProfile.isLikedByMe,
                createdAt: updatedProfile.createdAt,
                updatedAt: Date(),
                lastTokenAuthAt: Date()
            )
            return updatedProfile
        } else {
            throw AppError.custom("이미지 업로드 중 오류가 발생했습니다.", code: 500)
        }
    }
    
    func uploadImage(imageData: Data) async throws -> ProfileEntitiy {
        try await simulateNetworkDelay()
        
        if imageData.count > 5_000_000 {
            throw AppError.custom("이미지 용량이 너무 큽니다. (최대 5MB)", code: 413)
        }
        
        // Simulate adding new image to gallery
        var updatedProfile = myProfile
        let newImageIndex = Int.random(in: 100...999)
        let newImage = ImageEntity(
            url: Self.sampleImageURL(newImageIndex),
            publicId: "profile-images/\(updatedProfile.id)_gallery_\(newImageIndex)"
        )
        
        var updatedImages = updatedProfile.images
        updatedImages.append(newImage)
        
        updatedProfile = ProfileEntitiy(
            id: updatedProfile.id,
            nickname: updatedProfile.nickname,
            email: updatedProfile.email,
            profileImage: updatedProfile.profileImage,
            images: updatedImages,
            mbti: updatedProfile.mbti,
            qnas: updatedProfile.qnas,
            gender: updatedProfile.gender,
            height: updatedProfile.height,
            weight: updatedProfile.weight,
            bodyType: updatedProfile.bodyType,
            location: updatedProfile.location,
            introduction: updatedProfile.introduction,
            isNew: updatedProfile.isNew,
            isLikedByMe: updatedProfile.isLikedByMe,
            createdAt: updatedProfile.createdAt,
            updatedAt: Date(),
            lastTokenAuthAt: updatedProfile.lastTokenAuthAt
        )
        
        return updatedProfile
    }
    
    func updateGender(gender: GenderEntity) async throws -> ProfileEntitiy {
        try await simulateNetworkDelay()
        
        var updatedProfile = myProfile
        updatedProfile = ProfileEntitiy(
            id: updatedProfile.id,
            nickname: updatedProfile.nickname,
            email: updatedProfile.email,
            profileImage: updatedProfile.profileImage,
            images: updatedProfile.images,
            mbti: updatedProfile.mbti,
            qnas: updatedProfile.qnas,
            gender: gender,
            height: updatedProfile.height,
            weight: updatedProfile.weight,
            bodyType: updatedProfile.bodyType,
            location: updatedProfile.location,
            introduction: updatedProfile.introduction,
            isNew: updatedProfile.isNew,
            isLikedByMe: updatedProfile.isLikedByMe,
            createdAt: updatedProfile.createdAt,
            updatedAt: Date(),
            lastTokenAuthAt: updatedProfile.lastTokenAuthAt
        )
        
        return updatedProfile
    }
    
    func updatePhysicalInfo(height: CGFloat, weight: CGFloat) async throws -> ProfileEntitiy {
        try await simulateNetworkDelay()
        
        // Validate input
        if height < 140 || height > 220 {
            throw AppError.custom("키는 140cm에서 220cm 사이여야 합니다.", code: 400)
        }
        
        if weight < 30 || weight > 150 {
            throw AppError.custom("몸무게는 30kg에서 150kg 사이여야 합니다.", code: 400)
        }
        
        var updatedProfile = myProfile
        updatedProfile = ProfileEntitiy(
            id: updatedProfile.id,
            nickname: updatedProfile.nickname,
            email: updatedProfile.email,
            profileImage: updatedProfile.profileImage,
            images: updatedProfile.images,
            mbti: updatedProfile.mbti,
            qnas: updatedProfile.qnas,
            gender: updatedProfile.gender,
            height: height,
            weight: weight,
            bodyType: updatedProfile.bodyType,
            location: updatedProfile.location,
            introduction: updatedProfile.introduction,
            isNew: updatedProfile.isNew,
            isLikedByMe: updatedProfile.isLikedByMe,
            createdAt: updatedProfile.createdAt,
            updatedAt: Date(),
            lastTokenAuthAt: updatedProfile.lastTokenAuthAt
        )
        
        return updatedProfile
    }
    
    func deleteImage(publicId: String) async throws -> ProfileEntitiy {
        try await simulateNetworkDelay()
        
        var updatedProfile = myProfile
        let filteredImages = updatedProfile.images.filter { $0.publicId != publicId }
        
        updatedProfile = ProfileEntitiy(
            id: updatedProfile.id,
            nickname: updatedProfile.nickname,
            email: updatedProfile.email,
            profileImage: updatedProfile.profileImage,
            images: filteredImages,
            mbti: updatedProfile.mbti,
            qnas: updatedProfile.qnas,
            gender: updatedProfile.gender,
            height: updatedProfile.height,
            weight: updatedProfile.weight,
            bodyType: updatedProfile.bodyType,
            location: updatedProfile.location,
            introduction: updatedProfile.introduction,
            isNew: updatedProfile.isNew,
            isLikedByMe: updatedProfile.isLikedByMe,
            createdAt: updatedProfile.createdAt,
            updatedAt: Date(),
            lastTokenAuthAt: updatedProfile.lastTokenAuthAt
        )
        
        return updatedProfile
    }
    
    func updateNickname(nickname: String) async throws -> ProfileEntitiy {
        try await simulateNetworkDelay()
        
        // Validate nickname
        if nickname.count < 2 {
            throw AppError.custom("닉네임은 최소 2글자 이상이어야 합니다.", code: 400)
        }
        
        if nickname.count > 20 {
            throw AppError.custom("닉네임은 최대 20글자까지 가능합니다.", code: 400)
        }
        
        // Simulate duplicate check
        let duplicateNicknames = ["admin", "test", "관리자"]
        if duplicateNicknames.contains(nickname) {
            throw AppError.custom("이미 사용 중인 닉네임입니다.", code: 409)
        }
        
        var updatedProfile = myProfile
        updatedProfile = ProfileEntitiy(
            id: updatedProfile.id,
            nickname: nickname,
            email: updatedProfile.email,
            profileImage: updatedProfile.profileImage,
            images: updatedProfile.images,
            mbti: updatedProfile.mbti,
            qnas: updatedProfile.qnas,
            gender: updatedProfile.gender,
            height: updatedProfile.height,
            weight: updatedProfile.weight,
            bodyType: updatedProfile.bodyType,
            location: updatedProfile.location,
            introduction: updatedProfile.introduction,
            isNew: updatedProfile.isNew,
            isLikedByMe: updatedProfile.isLikedByMe,
            createdAt: updatedProfile.createdAt,
            updatedAt: Date(),
            lastTokenAuthAt: updatedProfile.lastTokenAuthAt
        )
        
        return updatedProfile
    }
    
    func updateMBTI(mbti: MBTIEntity) async throws -> ProfileEntitiy {
        try await simulateNetworkDelay()
        
        var updatedProfile = myProfile
        updatedProfile = ProfileEntitiy(
            id: updatedProfile.id,
            nickname: updatedProfile.nickname,
            email: updatedProfile.email,
            profileImage: updatedProfile.profileImage,
            images: updatedProfile.images,
            mbti: mbti,
            qnas: updatedProfile.qnas,
            gender: updatedProfile.gender,
            height: updatedProfile.height,
            weight: updatedProfile.weight,
            bodyType: updatedProfile.bodyType,
            location: updatedProfile.location,
            introduction: updatedProfile.introduction,
            isNew: updatedProfile.isNew,
            isLikedByMe: updatedProfile.isLikedByMe,
            createdAt: updatedProfile.createdAt,
            updatedAt: Date(),
            lastTokenAuthAt: updatedProfile.lastTokenAuthAt
        )
        
        return updatedProfile
    }
    
    func updateIntroduce(introduce: String) async throws -> ProfileEntitiy {
        try await simulateNetworkDelay()
        
        if introduce.count > 500 {
            throw AppError.custom("자기소개는 최대 500자까지 입력 가능합니다.", code: 400)
        }
        
        var updatedProfile = myProfile
        updatedProfile = ProfileEntitiy(
            id: updatedProfile.id,
            nickname: updatedProfile.nickname,
            email: updatedProfile.email,
            profileImage: updatedProfile.profileImage,
            images: updatedProfile.images,
            mbti: updatedProfile.mbti,
            qnas: updatedProfile.qnas,
            gender: updatedProfile.gender,
            height: updatedProfile.height,
            weight: updatedProfile.weight,
            bodyType: updatedProfile.bodyType,
            location: updatedProfile.location,
            introduction: introduce,
            isNew: updatedProfile.isNew,
            isLikedByMe: updatedProfile.isLikedByMe,
            createdAt: updatedProfile.createdAt,
            updatedAt: Date(),
            lastTokenAuthAt: updatedProfile.lastTokenAuthAt
        )
        
        return updatedProfile
    }
    
    func addQNA(question: String, answer: String) async throws -> ProfileEntitiy {
        try await simulateNetworkDelay()
        
        if question.isEmpty || answer.isEmpty {
            throw AppError.custom("질문과 답변을 모두 입력해주세요.", code: 400)
        }
        
        var updatedProfile = myProfile
        let newQnA = QnAEntity(
            id: "qna_\(Date().timeIntervalSince1970)",
            question: question,
            answer: answer,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        var updatedQnAs = updatedProfile.qnas
        updatedQnAs.append(newQnA)
        
        updatedProfile = ProfileEntitiy(
            id: updatedProfile.id,
            nickname: updatedProfile.nickname,
            email: updatedProfile.email,
            profileImage: updatedProfile.profileImage,
            images: updatedProfile.images,
            mbti: updatedProfile.mbti,
            qnas: updatedQnAs,
            gender: updatedProfile.gender,
            height: updatedProfile.height,
            weight: updatedProfile.weight,
            bodyType: updatedProfile.bodyType,
            location: updatedProfile.location,
            introduction: updatedProfile.introduction,
            isNew: updatedProfile.isNew,
            isLikedByMe: updatedProfile.isLikedByMe,
            createdAt: updatedProfile.createdAt,
            updatedAt: Date(),
            lastTokenAuthAt: updatedProfile.lastTokenAuthAt
        )
        
        return updatedProfile
    }
    
    func getQnA(qnaId: String) async throws -> QnAEntity {
        MockDataGenerator.shared.generateRandomQnAs(count: 1)[0]
    }
    
    func deleteQNA(qnaId: String) async throws -> ProfileEntitiy {
        try await simulateNetworkDelay()
        
        var updatedProfile = myProfile
        let filteredQnAs = updatedProfile.qnas.filter { $0.id != qnaId }
        
        updatedProfile = ProfileEntitiy(
            id: updatedProfile.id,
            nickname: updatedProfile.nickname,
            email: updatedProfile.email,
            profileImage: updatedProfile.profileImage,
            images: updatedProfile.images,
            mbti: updatedProfile.mbti,
            qnas: filteredQnAs,
            gender: updatedProfile.gender,
            height: updatedProfile.height,
            weight: updatedProfile.weight,
            bodyType: updatedProfile.bodyType,
            location: updatedProfile.location,
            introduction: updatedProfile.introduction,
            isNew: updatedProfile.isNew,
            isLikedByMe: updatedProfile.isLikedByMe,
            createdAt: updatedProfile.createdAt,
            updatedAt: Date(),
            lastTokenAuthAt: updatedProfile.lastTokenAuthAt
        )
        
        return updatedProfile
    }
    
    func updateQNA(qnaId: String, answer: String) async throws -> ProfileEntitiy {
        try await simulateNetworkDelay()
        
        if answer.isEmpty {
            throw AppError.custom("답변을 입력해주세요.", code: 400)
        }
        
        var updatedProfile = myProfile
        var updatedQnAs = updatedProfile.qnas
        
        if let index = updatedQnAs.firstIndex(where: { $0.id == qnaId }) {
            let updatedQnA = QnAEntity(
                id: updatedQnAs[index].id,
                question: updatedQnAs[index].question,
                answer: answer,
                createdAt: updatedQnAs[index].createdAt,
                updatedAt: Date()
            )
            updatedQnAs[index] = updatedQnA
        }
        
        updatedProfile = ProfileEntitiy(
            id: updatedProfile.id,
            nickname: updatedProfile.nickname,
            email: updatedProfile.email,
            profileImage: updatedProfile.profileImage,
            images: updatedProfile.images,
            mbti: updatedProfile.mbti,
            qnas: updatedQnAs,
            gender: updatedProfile.gender,
            height: updatedProfile.height,
            weight: updatedProfile.weight,
            bodyType: updatedProfile.bodyType,
            location: updatedProfile.location,
            introduction: updatedProfile.introduction,
            isNew: updatedProfile.isNew,
            isLikedByMe: updatedProfile.isLikedByMe,
            createdAt: updatedProfile.createdAt,
            updatedAt: Date(),
            lastTokenAuthAt: updatedProfile.lastTokenAuthAt
        )
        
        return updatedProfile
    }
    
    func search(profileId: String) async throws -> ProfileEntitiy {
        try await simulateNetworkDelay()
        
        // Search in all mock profiles
        if let profile = allMockProfiles.first(where: { $0.id == profileId }) {
            return profile
        }
        
        // If not found, return myProfile for "me" ID
        if profileId == "me" {
            return myProfile
        }
        
        throw AppError.custom("프로필을 찾을 수 없습니다.", code: 404)
    }
    
    // MARK: - Additional Helper Methods for Testing
    func getAllProfiles() -> [ProfileEntitiy] {
        return dataStore.getAllProfiles()
    }
    
    func getRandomProfiles(count: Int = 5) -> [ProfileEntitiy] {
        return Array(dataStore.getAllProfiles().shuffled().prefix(count))
    }
    
    func getProfilesLikedByMe() -> [ProfileEntitiy] {
        return dataStore.getLikedProfiles(by: "me")
    }
    
    func getNewProfiles() -> [ProfileEntitiy] {
        return dataStore.getNewProfiles(for: "me")
    }
    
    func updateFCM(fcmToken: String) async throws {
        
    }
    
    func updateLocation(latitude: Double, longitude: Double) async throws {
        
    }
}
