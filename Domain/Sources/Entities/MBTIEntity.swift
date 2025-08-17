//
//  MBTIEntity.swift
//  Domain
//
//  Created by 신동규 on 8/14/25.
//

public enum MBTIEntity: CaseIterable {
    case intj
    case intp
    case entj
    case entp
    case infj
    case infp
    case enfj
    case enfp
    case istj
    case isfj
    case estj
    case esfj
    case istp
    case isfp
    case estp
    case esfp
    
    public var text: String {
        switch self {
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
