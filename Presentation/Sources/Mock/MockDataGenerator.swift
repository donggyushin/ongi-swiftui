//
//  MockDataGenerator.swift
//  Presentation
//
//  Created by 신동규 on 8/21/25.
//

import Foundation
import Domain

public class MockDataGenerator {
    
    public static let shared = MockDataGenerator()
    
    private init() {}
    
    // MARK: - Korean Names Generator
    private let koreanLastNames = [
        "김", "이", "박", "최", "정", "강", "조", "윤", "장", "임",
        "한", "오", "서", "신", "권", "황", "안", "송", "전", "홍"
    ]
    
    private let koreanFirstNames = [
        "서준", "민준", "도윤", "예준", "시우", "주원", "하준", "지호", "지후", "준서",
        "서연", "하윤", "지우", "서현", "민서", "하은", "윤서", "지유", "지원", "예은"
    ]
    
    private let nicknames = [
        "햇살같은", "달콤한", "상큼한", "따뜻한", "시원한", "예쁜", "멋진", "귀여운", "차분한", "활발한",
        "레이지", "코코", "루루", "피치", "민트", "베리", "허니", "초코", "바닐라", "모카",
        "커피러버", "북벌레", "여행러", "음악애호가", "운동하는", "요리사", "사진작가", "개발자", "디자이너", "작가"
    ]
    
    // MARK: - Profile Introduction Templates
    private let introductionTemplates = [
        "안녕하세요! 새로운 인연을 만나고 싶어요 😊",
        "함께 즐거운 시간을 보낼 수 있는 분을 찾고 있어요.",
        "소소한 일상을 공유하며 서로를 알아가고 싶습니다.",
        "진솔한 대화를 나눌 수 있는 사람이면 좋겠어요.",
        "같은 취미를 가진 분과 만나고 싶어요!",
        "서로를 응원해줄 수 있는 관계를 원해요.",
        "일상의 소중함을 함께 느낄 수 있는 분을 찾아요.",
        "웃음이 많은 즐거운 만남을 기대해요 🌟",
        "서로의 꿈을 응원해주는 관계면 좋겠어요.",
        "따뜻한 마음을 가진 분과 인연이 되고 싶어요."
    ]
    
    // MARK: - QnA Templates
    private let questionAnswerPairs = [
        (
            question: "가장 좋아하는 취미는 무엇인가요?",
            answers: [
                "책 읽기와 새로운 기술 배우기를 정말 좋아해요. 개인적으로나 전문적으로 성장하는 데 도움이 돼요.",
                "등산을 좋아해요. 자연 속에서 힐링하는 시간이 정말 소중해요.",
                "요리하는 것을 좋아해요. 새로운 레시피에 도전하는 게 재미있어요.",
                "사진 찍기를 좋아해요. 일상의 소중한 순간들을 기록하는 게 의미있어요.",
                "음악 듣기와 영화 감상을 좋아해요. 감성적인 시간을 보내는 게 좋아요."
            ]
        ),
        (
            question: "이상형은 어떤 사람인가요?",
            answers: [
                "서로를 존중하고 함께 성장할 수 있는 사람이 좋아요. 유머 감각도 중요하고요!",
                "진실하고 따뜻한 마음을 가진 분이면 좋겠어요.",
                "서로의 꿈을 응원해주고 함께 노력할 수 있는 사람이요.",
                "대화가 잘 통하고 함께 있으면 편안한 사람이 좋아요.",
                "긍정적이고 밝은 에너지를 가진 분과 만나고 싶어요."
            ]
        ),
        (
            question: "여행에서 가장 기억에 남는 곳은?",
            answers: [
                "제주도에서 본 일출이 정말 잊을 수 없어요. 자연의 아름다움에 감동했어요.",
                "부산 바다에서 먹은 회가 정말 맛있었어요. 현지 음식은 역시 달라요.",
                "경주의 역사적인 유적들을 보며 우리 문화의 소중함을 느꼈어요.",
                "강릉에서 먹은 커피와 바다 풍경이 완벽한 조합이었어요.",
                "설악산에서의 등산이 힘들었지만 정상에서 본 풍경은 최고였어요."
            ]
        ),
        (
            question: "스트레스 받을 때 어떻게 푸시나요?",
            answers: [
                "친구들과 맛있는 걸 먹으면서 수다 떨기! 그리고 혼자 음악 들으면서 산책하는 것도 좋아해요.",
                "운동을 해요. 헬스장에서 땀 흘리면 스트레스가 확 풀려요.",
                "좋아하는 드라마나 영화를 보면서 힐링해요.",
                "요리를 하거나 베이킹을 해요. 집중하다 보면 스트레스가 사라져요.",
                "독서를 하거나 일기를 써요. 마음을 정리하는 데 도움이 돼요."
            ]
        ),
        (
            question: "인생에서 가장 소중한 것은?",
            answers: [
                "가족과 친구들이죠. 사랑하는 사람들과의 소중한 시간이 제일 중요해요.",
                "건강이요. 건강해야 모든 걸 할 수 있으니까요.",
                "새로운 경험과 성장이요. 계속 배우고 발전하는 게 중요해요.",
                "인간관계예요. 좋은 사람들과의 만남이 인생을 풍요롭게 해요.",
                "꿈과 목표예요. 이루고 싶은 것들이 있어야 삶이 의미있어요."
            ]
        ),
        (
            question: "좋아하는 음식은 무엇인가요?",
            answers: [
                "파스타와 한식을 정말 좋아해요. 특히 엄마가 해주시는 김치찌개는 최고예요!",
                "일본 음식을 좋아해요. 초밥이나 라멘을 먹을 때 행복해요.",
                "디저트를 좋아해요. 케이크나 마카롱 같은 달콤한 것들이 좋아요.",
                "매운 음식을 좋아해요. 떡볶이나 마라탕 먹을 때 스트레스가 풀려요.",
                "집밥이 최고예요. 간단한 된장찌개와 김치가 제일 맛있어요."
            ]
        )
    ]
    
    // MARK: - Data Generation Methods
    public func generateRandomProfile(id: String? = nil) -> ProfileEntitiy {
        let profileId = id ?? "generated_\(UUID().uuidString.prefix(8))"
        let lastName = koreanLastNames.randomElement()!
        let firstName = koreanFirstNames.randomElement()!
        let nickname = "\(nicknames.randomElement()!)\(lastName)\(firstName)"
        
        let imageIndex = Int.random(in: 1...100)
        let gender = GenderEntity.allCases.randomElement()!
        let mbti = MBTIEntity.allCases.randomElement()!
        let bodyType = BodyType.allCases.randomElement()!
        
        let height: CGFloat = gender == .male ? 
            CGFloat.random(in: 170...185) : CGFloat.random(in: 155...170)
        let weight: CGFloat = gender == .male ? 
            CGFloat.random(in: 65...80) : CGFloat.random(in: 45...60)
        
        return ProfileEntitiy(
            id: profileId,
            nickname: nickname,
            email: "\(nickname.lowercased())@example.com",
            profileImage: generateRandomImage(index: imageIndex),
            images: generateRandomImages(count: Int.random(in: 1...4), startIndex: imageIndex),
            mbti: mbti,
            qnas: generateRandomQnAs(count: Int.random(in: 1...3)),
            gender: gender,
            height: height,
            weight: weight,
            bodyType: bodyType,
            introduction: introductionTemplates.randomElement()!,
            isNew: Bool.random(),
            isLikedByMe: Bool.random(),
            createdAt: generateRandomDate(withinDays: 30),
            updatedAt: generateRandomDate(withinDays: 7)
        )
    }
    
    public func generateRandomImage(index: Int) -> ImageEntity {
        return ImageEntity(
            url: URL(string: "https://picsum.photos/400/600?random=\(index)")!,
            publicId: "profile-images/random_\(index)"
        )
    }
    
    public func generateRandomImages(count: Int, startIndex: Int = 1) -> [ImageEntity] {
        return (0..<count).map { index in
            generateRandomImage(index: startIndex + index)
        }
    }
    
    public func generateRandomQnAs(count: Int) -> [QnAEntity] {
        let shuffledQAs = questionAnswerPairs.shuffled()
        
        return (0..<min(count, shuffledQAs.count)).map { index in
            let qa = shuffledQAs[index]
            let answer = qa.answers.randomElement()!
            
            return QnAEntity(
                id: "qna_\(UUID().uuidString.prefix(8))",
                question: qa.question,
                answer: answer,
                createdAt: generateRandomDate(withinDays: 30),
                updatedAt: generateRandomDate(withinDays: 7)
            )
        }
    }
    
    public func generateRandomDate(withinDays days: Int) -> Date {
        let now = Date()
        let randomInterval = TimeInterval.random(in: 0...(days * 24 * 60 * 60))
        return now.addingTimeInterval(-randomInterval)
    }
    
    // MARK: - Batch Generation
    public func generateProfiles(count: Int) -> [ProfileEntitiy] {
        return (0..<count).map { index in
            generateRandomProfile(id: "batch_\(index)")
        }
    }
    
    public func generateProfilesWithScenario(_ scenario: MockScenario, count: Int) -> [ProfileEntitiy] {
        let profiles = generateProfiles(count: count)
        
        switch scenario {
        case .newUser:
            // Most profiles should be new
            return profiles.enumerated().map { index, profile in
                let isNew = index < Int(Double(count) * 0.8) // 80% new
                return updateProfile(profile, isNew: isNew)
            }
            
        case .popular:
            // Most profiles should like me
            return profiles.enumerated().map { index, profile in
                let isLikedByMe = index < Int(Double(count) * 0.7) // 70% liked by me
                return updateProfile(profile, isLikedByMe: isLikedByMe)
            }
            
        case .empty:
            return []
            
        default:
            return profiles
        }
    }
    
    private func updateProfile(_ profile: ProfileEntitiy, isNew: Bool? = nil, isLikedByMe: Bool? = nil) -> ProfileEntitiy {
        return ProfileEntitiy(
            id: profile.id,
            nickname: profile.nickname,
            email: profile.email,
            profileImage: profile.profileImage,
            images: profile.images,
            mbti: profile.mbti,
            qnas: profile.qnas,
            gender: profile.gender,
            height: profile.height,
            weight: profile.weight,
            bodyType: profile.bodyType,
            introduction: profile.introduction,
            isNew: isNew ?? profile.isNew,
            isLikedByMe: isLikedByMe ?? profile.isLikedByMe,
            createdAt: profile.createdAt,
            updatedAt: profile.updatedAt
        )
    }
    
    // MARK: - Test Data Presets
    public func createTestPresets() -> [String: [ProfileEntitiy]] {
        return [
            "popular_users": generateProfilesWithScenario(.popular, count: 10),
            "new_users": generateProfilesWithScenario(.newUser, count: 5),
            "diverse_profiles": generateProfiles(count: 8),
            "minimal_profiles": generateProfiles(count: 2)
        ]
    }
}

// MARK: - Extensions for Testing
extension MockDataGenerator {
    
    public func createSpecificProfile(
        nickname: String,
        gender: GenderEntity,
        mbti: MBTIEntity,
        isNew: Bool = false,
        isLikedByMe: Bool = false
    ) -> ProfileEntitiy {
        let imageIndex = Int.random(in: 1...100)
        
        return ProfileEntitiy(
            id: "custom_\(UUID().uuidString.prefix(8))",
            nickname: nickname,
            email: "\(nickname.lowercased())@example.com",
            profileImage: generateRandomImage(index: imageIndex),
            images: generateRandomImages(count: 2, startIndex: imageIndex),
            mbti: mbti,
            qnas: generateRandomQnAs(count: 2),
            gender: gender,
            height: gender == .male ? CGFloat.random(in: 170...185) : CGFloat.random(in: 155...170),
            weight: gender == .male ? CGFloat.random(in: 65...80) : CGFloat.random(in: 45...60),
            bodyType: BodyType.allCases.randomElement()!,
            introduction: introductionTemplates.randomElement()!,
            isNew: isNew,
            isLikedByMe: isLikedByMe,
            createdAt: generateRandomDate(withinDays: 30),
            updatedAt: generateRandomDate(withinDays: 7)
        )
    }
}