import SwiftUI

public enum PretendardFont: String, CaseIterable {
    case thin = "Pretendard-Thin"
    case extraLight = "Pretendard-ExtraLight"
    case light = "Pretendard-Light"
    case regular = "Pretendard-Regular"
    case medium = "Pretendard-Medium"
    case semiBold = "Pretendard-SemiBold"
    case bold = "Pretendard-Bold"
    case extraBold = "Pretendard-ExtraBold"
    case black = "Pretendard-Black"
    
    public func font(size: CGFloat) -> Font {
        return Font.custom(self.rawValue, size: size)
    }
}

public extension Font {
    static func pretendard(_ weight: PretendardFont, size: CGFloat) -> Font {
        return weight.font(size: size)
    }
    
    static func pretendardTitle1(_ weight: PretendardFont = .bold) -> Font {
        return weight.font(size: 28)
    }
    
    static func pretendardTitle2(_ weight: PretendardFont = .bold) -> Font {
        return weight.font(size: 22)
    }
    
    static func pretendardTitle3(_ weight: PretendardFont = .semiBold) -> Font {
        return weight.font(size: 20)
    }
    
    static func pretendardHeadline(_ weight: PretendardFont = .semiBold) -> Font {
        return weight.font(size: 17)
    }
    
    static func pretendardBody(_ weight: PretendardFont = .regular) -> Font {
        return weight.font(size: 17)
    }
    
    static func pretendardCallout(_ weight: PretendardFont = .regular) -> Font {
        return weight.font(size: 16)
    }
    
    static func pretendardSubheadline(_ weight: PretendardFont = .regular) -> Font {
        return weight.font(size: 15)
    }
    
    static func pretendardFootnote(_ weight: PretendardFont = .regular) -> Font {
        return weight.font(size: 13)
    }
    
    static func pretendardCaption1(_ weight: PretendardFont = .regular) -> Font {
        return weight.font(size: 12)
    }
    
    static func pretendardCaption2(_ weight: PretendardFont = .regular) -> Font {
        return weight.font(size: 11)
    }
}