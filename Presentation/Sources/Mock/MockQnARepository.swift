//
//  MockQnARepository.swift
//  Domain
//
//  Created by 신동규 on 8/16/25.
//

import Domain
import Foundation

final class MockQnARepository: PQnARepository {
    func getExamples() async throws -> [QnAEntity] {
        let currentDate = Date()
        
        try await Task.sleep(for: .seconds(0.5))
        
        return [
            QnAEntity(
                id: "1",
                question: "나의 취미는 무엇인가요?",
                answer: "저는 여행과 음악 감상을 좋아해요. 새로운 곳을 탐험하며 그 지역의 문화를 체험하는 것이 즐겁고, 다양한 장르의 음악을 들으며 감정을 정화하는 시간을 가져요.",
                createdAt: currentDate,
                updatedAt: currentDate
            ),
            QnAEntity(
                id: "2",
                question: "가장 좋아하는 음식은?",
                answer: "저는 파스타를 정말 좋아해요! 특히 크림 파스타와 토마토 파스타 모두 좋아하는데, 직접 만들어 먹는 것도 즐기고 있어요. 요리하는 과정에서 스트레스도 해소되고 성취감도 느껴져요.",
                createdAt: currentDate,
                updatedAt: currentDate
            ),
            QnAEntity(
                id: "3",
                question: "어떤 일을 하고 있나요?",
                answer: "현재 IT 회사에서 개발자로 일하고 있어요. 새로운 기술을 배우고 적용하는 것이 즐겁고, 팀원들과 협업하며 문제를 해결해 나가는 과정에서 많은 보람을 느끼고 있어요.",
                createdAt: currentDate,
                updatedAt: currentDate
            ),
            QnAEntity(
                id: "4",
                question: "스트레스 해소 방법은?",
                answer: "산책이나 러닝을 하면서 자연을 느끼는 것을 좋아해요. 몸을 움직이며 머리를 비우는 시간이 필요할 때가 많은데, 운동 후에는 마음도 개운해지고 새로운 아이디어도 떠올라요.",
                createdAt: currentDate,
                updatedAt: currentDate
            ),
            QnAEntity(
                id: "5",
                question: "꿈이나 목표가 있다면?",
                answer: "개인적으로는 건강한 라이프스타일을 유지하면서 지속적으로 성장하는 것이 목표예요. 일적으로는 더 많은 사람들에게 도움이 되는 서비스를 만들고 싶고, 팀을 이끌 수 있는 리더가 되고 싶어요.",
                createdAt: currentDate,
                updatedAt: currentDate
            ),
            QnAEntity(
                id: "6",
                question: "어떤 성격인지 소개해주세요",
                answer: "기본적으로 긍정적이고 호기심이 많은 편이에요. 새로운 것을 배우는 것을 좋아하고, 다른 사람들과 소통하며 서로의 생각을 나누는 것을 즐깁니다. 때로는 완벽주의적인 면도 있지만, 실패를 두려워하지 않고 도전하려고 노력해요.",
                createdAt: currentDate,
                updatedAt: currentDate
            )
        ]
    }
}
