//
//  Tooltip.swift
//  Bythen
//
//  Created by edisurata on 16/10/24.
//

import SwiftUI

struct ArrowShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

enum ToolTipStyle {
    case regular
    case smallArrowedTop
    case smallArrowedBottom
}

enum ToolTipTextStyle {
    case bold
    case regular
}

enum ToolTipBackgroundStyle {
    case light
    case dark
    
    var borderColor: Color {
        self == .dark ? .byteBlack : .white
    }
    
    var backgroundColor: Color {
        self == .light ? .white : .byteBlack
    }
    
    var textColor: Color {
        self == .light ? .byteBlack : .white
    }
}

struct Tooltip: View {
    @State var content: String
    @State var style: ToolTipStyle = .regular
    @State var textStyle: ToolTipTextStyle = .regular
    @State var backgroundStyle: ToolTipBackgroundStyle = .light
    
    private var font: Font {
        switch textStyle {
        case .bold: FontStyle.foundersGrotesk(.bold, size: 12)
        case .regular: FontStyle.neueMontreal(size: 12)
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            if style == .smallArrowedTop {
                ArrowShape()
                    .fill(backgroundStyle.backgroundColor)
                    .frame(width: 16, height: 8)
                    .rotationEffect(.radians(.pi))
            }
            
            Text(content)
                .lineLimit(nil)
                .conditionalModifier(style == .regular) { view in
                    view.frame(maxWidth: .infinity, alignment: .leading)
                }
                .font(font)
                .foregroundStyle(backgroundStyle.textColor)
                .conditionalModifier(style == .regular) { view in
                    view.padding(16)
                }
                .conditionalModifier(style == .smallArrowedTop || style == .smallArrowedBottom) { view in
                    view
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                }
                .background(RoundedCorner(radius: 8)
                    .fill(
                        backgroundStyle.backgroundColor,
                        strokeBorder: backgroundStyle.borderColor, lineWidth: 1)
                )
                .fixedSize(horizontal: false, vertical: true)
            
            if style == .smallArrowedBottom {
                ArrowShape()
                    .fill(backgroundStyle.backgroundColor)
                    .frame(width: 16, height: 8)
            }
        }
        .clipShape(Rectangle())
        .conditionalModifier(style == .smallArrowedTop || style == .smallArrowedBottom) { view in
            view.shadow(radius: 14)
        }
    }
}

struct TooltipAnchorPreferenceKey: PreferenceKey {
    static var defaultValue: Anchor<CGRect>? = nil
    
    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = nextValue()
    }
}

struct TooltipTargetModifier: ViewModifier {
    let tooltipContent: String
    @Binding var isTooltipVisible: Bool
    var style: ToolTipStyle
    var textStyle: ToolTipTextStyle
    
    func body(content: Content) -> some View {
        content
            .anchorPreference(key: TooltipAnchorPreferenceKey.self, value: .bounds, transform: { $0 })
            .overlayPreferenceValue(TooltipAnchorPreferenceKey.self) { anchor in
                GeometryReader { proxy in
                    if isTooltipVisible, let anchor {
                        let bounds = proxy[anchor] // Extract bounds to avoid capturing proxy
                        Tooltip(content: tooltipContent, style: style, textStyle: textStyle)
                            .fixedSize(horizontal: false, vertical: false) // Allow natural size in both directions
                            .position(
                                x: bounds.midX,  // Center horizontally relative to the target
                                y: bounds.minY - 15 // Position above the target with a small offset
                            )
                            .transition(.opacity) // Smooth show/hide effect
                    }
                }
            }
    }
}



// Extension for Tooltip Modifier
extension View {
    func attachSmallArrowedTooltip(
        isTooltipVisible: Binding<Bool>,
        content: String
    ) -> some View {
        self.modifier(
            TooltipTargetModifier(
                tooltipContent: content,
                isTooltipVisible: isTooltipVisible,
                style: .smallArrowedBottom,
                textStyle: .bold
            )
        )
    }
}

#Preview {
    VStack(alignment: .center, spacing: 0) {
        Tooltip(content: "THis is a long text this is a long text THis is a long text this is a long text THis is a long text this is a long text", style: .regular, textStyle: .regular)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.red)
}
