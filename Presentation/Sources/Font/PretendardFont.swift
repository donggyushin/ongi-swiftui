import SwiftUI
import CoreText

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
    
    private static var isRegistered = false
    
    public static func registerCustomFonts() {
        guard !isRegistered else { return }
        
        let fontFiles = [
            "Pretendard-Thin",
            "Pretendard-ExtraLight",
            "Pretendard-Light",
            "Pretendard-Regular",
            "Pretendard-Medium",
            "Pretendard-SemiBold",
            "Pretendard-Bold",
            "Pretendard-ExtraBold",
            "Pretendard-Black"
        ]
        
        for font in fontFiles {
            guard let url = Bundle.module.url(forResource: "\(font)", withExtension: "otf") else {
                print("Failed to find font file: \(font)")
                continue
            }
            
            let result = CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
            if !result {
                print("Failed to register font: \(font)")
            }
        }
        
        isRegistered = true
    }
    
    public func font(size: CGFloat) -> Font {
        PretendardFont.registerCustomFonts()
        return Font.custom(self.rawValue, size: size)
    }
}

public extension Font {
    static func pretendard(_ weight: PretendardFont, size: CGFloat) -> Font {
        PretendardFont.registerCustomFonts()
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
