//
//  GenderEntity.swift
//  Presentation
//
//  Created by 신동규 on 8/15/25.
//

public enum GenderEntity: CaseIterable {
    case male
    case female
    
    public var text: String {
        switch self {
        case .male:
            return "MALE"
        case .female:
            return "FEMALE"
        }
    }
}
