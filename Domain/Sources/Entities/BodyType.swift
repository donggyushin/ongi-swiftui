//
//  BodyType.swift
//  Domain
//
//  Created by 신동규 on 8/15/25.
//

public enum BodyType {
    case slim
    case normal
    case chubby
    case large
    
    public var text: String {
        switch self {
        case .slim:
            return "마른"
        case .normal:
            return "보통"
        case .chubby:
            return "통통"
        case .large:
            return "큰"
        }
    }
}
