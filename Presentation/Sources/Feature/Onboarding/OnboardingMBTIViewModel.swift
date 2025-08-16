//
//  OnboardingMBTIViewModel.swift
//  Presentation
//
//  Created by 신동규 on 8/16/25.
//

import Factory
import Domain
import SwiftUI
import Combine

final class OnboardingMBTIViewModel: ObservableObject {
    @Published var selectedMBTI: MBTIEntity?
    @Published var isLoading = false
    
    let mbtiOptions: [MBTIEntity] = [
        .intj, .intp, .entj, .entp,
        .infj, .infp, .enfj, .enfp,
        .istj, .isfj, .estj, .esfj,
        .istp, .isfp, .estp, .esfp
    ]
    
    func selectMBTI(_ mbti: MBTIEntity) {
        selectedMBTI = mbti
    }
    
    func mbtiDisplayText(_ mbti: MBTIEntity) -> String {
        switch mbti {
        case .intj: return "INTJ"
        case .intp: return "INTP"
        case .entj: return "ENTJ"
        case .entp: return "ENTP"
        case .infj: return "INFJ"
        case .infp: return "INFP"
        case .enfj: return "ENFJ"
        case .enfp: return "ENFP"
        case .istj: return "ISTJ"
        case .isfj: return "ISFJ"
        case .estj: return "ESTJ"
        case .esfj: return "ESFJ"
        case .istp: return "ISTP"
        case .isfp: return "ISFP"
        case .estp: return "ESTP"
        case .esfp: return "ESFP"
        }
    }
}
