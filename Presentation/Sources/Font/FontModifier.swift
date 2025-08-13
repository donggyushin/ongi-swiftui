import SwiftUI

public struct PretendardFontModifier: ViewModifier {
    let weight: PretendardFont
    let size: CGFloat
    
    public func body(content: Content) -> some View {
        content.font(.pretendard(weight, size: size))
    }
}

public extension View {
    func pretendardFont(_ weight: PretendardFont, size: CGFloat) -> some View {
        modifier(PretendardFontModifier(weight: weight, size: size))
    }
    
    func pretendardTitle1(_ weight: PretendardFont = .bold) -> some View {
        font(.pretendardTitle1(weight))
    }
    
    func pretendardTitle2(_ weight: PretendardFont = .bold) -> some View {
        font(.pretendardTitle2(weight))
    }
    
    func pretendardTitle3(_ weight: PretendardFont = .semiBold) -> some View {
        font(.pretendardTitle3(weight))
    }
    
    func pretendardHeadline(_ weight: PretendardFont = .semiBold) -> some View {
        font(.pretendardHeadline(weight))
    }
    
    func pretendardBody(_ weight: PretendardFont = .regular) -> some View {
        font(.pretendardBody(weight))
    }
    
    func pretendardCallout(_ weight: PretendardFont = .regular) -> some View {
        font(.pretendardCallout(weight))
    }
    
    func pretendardSubheadline(_ weight: PretendardFont = .regular) -> some View {
        font(.pretendardSubheadline(weight))
    }
    
    func pretendardFootnote(_ weight: PretendardFont = .regular) -> some View {
        font(.pretendardFootnote(weight))
    }
    
    func pretendardCaption1(_ weight: PretendardFont = .regular) -> some View {
        font(.pretendardCaption1(weight))
    }
    
    func pretendardCaption2(_ weight: PretendardFont = .regular) -> some View {
        font(.pretendardCaption2(weight))
    }
}