//
//  HiveToolTip.swift
//  Bythen
//
//  Created by erlina ng on 01/01/25.
//

import SwiftUI

struct HiveToolTip<TooltipContent: View>: ViewModifier {
    
    // MARK: - Initializer Properties
    private var enabled: Bool
    private var content: TooltipContent
    private var config: HiveToolTipConfig
    
    internal init(enabled: Bool, config: HiveToolTipConfig, @ViewBuilder content: @escaping () -> TooltipContent) {
        self.enabled = enabled
        self.config = config
        self.content = content()
    }
    
    // MARK: - Local state

    @State private var contentWidth: CGFloat = 10
    @State private var contentHeight: CGFloat = 10
    
    @State var animationOffset: CGFloat = 0
    @State var animation: Optional<Animation> = nil

    // MARK: - Computed properties

    var showArrow: Bool { config.showArrow && config.side.shouldShowArrow() }
    var actualArrowHeight: CGFloat { self.showArrow ? config.arrowHeight : 0 }

    var arrowOffsetX: CGFloat {
        switch config.side {
        case .bottom, .top:
            return 0
        case .left:
            return (contentWidth / 2 + config.arrowHeight / 2)
        case .right:
            return -(contentWidth / 2 + config.arrowHeight / 2)
        }
    }

    var arrowOffsetY: CGFloat {
        switch config.side {
        case .left, .right:
            return 0
        case .top:
            return (contentHeight / 2 + config.arrowHeight / 2)
        case .bottom:
            return -(contentHeight / 2 + config.arrowHeight / 2)
        }
    }

    // MARK: - Helper functions

    private func offsetHorizontal(_ g: GeometryProxy) -> CGFloat {
        switch config.side {
        case .left:
            return -(contentWidth + config.margin + actualArrowHeight + animationOffset)
        case .right:
            return g.size.width + config.margin + actualArrowHeight + animationOffset
        case .top, .bottom:
            return (g.size.width - contentWidth) / 2
        }
    }

    private func offsetVertical(_ g: GeometryProxy) -> CGFloat {
        switch config.side {
        case .top:
            return -(contentHeight + config.margin + actualArrowHeight + animationOffset)
        case .bottom:
            return g.size.height + config.margin + actualArrowHeight + animationOffset
        case .left, .right:
            return (g.size.height - contentHeight) / 2
        }
    }
    
    // MARK: - Animation stuff
    
    private func dispatchAnimation() {
        if (config.enableAnimation) {
            DispatchQueue.main.asyncAfter(deadline: .now() + config.animationTime) {
                self.animationOffset = config.animationOffset
                self.animation = config.animation
                DispatchQueue.main.asyncAfter(deadline: .now() + config.animationTime * 0.1) {
                    self.animationOffset = 0
                    
                    self.dispatchAnimation()
                }
            }
        }
    }

    // MARK: - TooltipModifier Body Properties

    private var sizeMeasurer: some View {
        GeometryReader { g in
            Text("")
                .onAppear {
                    self.contentWidth = config.width ?? g.size.width
                    self.contentHeight = config.height ?? g.size.height
                }
        }
    }

    private var arrowView: some View {
        guard let arrowAngle = config.side.getArrowAngleRadians() else {
            return AnyView(EmptyView())
        }

        return AnyView(arrowShape(angle: arrowAngle)
            .background(arrowShape(angle: arrowAngle)
                .frame(width: config.arrowWidth, height: config.arrowHeight)
                .foregroundColor(config.backgroundColor)
            ).frame(width: config.arrowWidth, height: config.arrowHeight)
            .offset(x: CGFloat(Int(self.arrowOffsetX)), y: CGFloat(Int(self.arrowOffsetY))))
    }

    private func arrowShape(angle: Double) -> AnyView {
        let shape = HiveArrowShape()
            .rotation(Angle(radians: angle))
            .foregroundColor(config.backgroundColor)
        return AnyView(shape)
    }

    var tooltipBody: some View {
        GeometryReader { g in
            ZStack {
                RoundedRectangle(cornerRadius: config.borderRadius, style: config.borderRadiusStyle)
                    .frame(width: contentWidth, height: contentHeight)
                    .foregroundColor(config.backgroundColor)
                
                ZStack {
                    content
                        .padding(16)
                        .frame(
                            width: config.width,
                            height: config.height
                        )
                        .fixedSize(horizontal: config.width == nil, vertical: true)
                }
                .background(self.sizeMeasurer)
                .overlay(self.arrowView)
            }
            .offset(x: self.offsetHorizontal(g), y: self.offsetVertical(g))
            .animation(self.animation)
            .zIndex(config.zIndex)
            .onAppear {
                self.dispatchAnimation()
            }
        }
    }

    // MARK: - ViewModifier properties

    func body(content: Content) -> some View {
        content
            .overlay(enabled ? tooltipBody.transition(config.transition) : nil)
    }
}

public struct HiveArrowShape: Shape {
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addLines([
            CGPoint(x: 0, y: rect.height),
            CGPoint(x: rect.width / 2, y: 0),
            CGPoint(x: rect.width, y: rect.height),
        ])
        return path
    }
}

public extension View {
    internal func tooltip<TooltipContent: View>(
        _ enabled: Bool = true,
        side: TooltipSide,
        width: CGFloat = 260,
        @ViewBuilder content: @escaping () -> TooltipContent
    ) -> some View {
        var tooltipConfig = DefaultTooltipConfig(side: side)
        tooltipConfig.width = width
        
        return modifier(HiveToolTip(
            enabled: enabled,
            config: tooltipConfig,
            content: content
        ))
    }
}
