//
//  HiveToolTipConfig.swift
//  Bythen
//
//  Created by erlina ng on 01/01/25.
//

import SwiftUI

public protocol HiveToolTipConfig {
    // MARK: - Alignment

    var side: TooltipSide { get set }
    var margin: CGFloat { get set }
    var zIndex: Double { get set }
    
    // MARK: - Sizes
    var width: CGFloat? { get set }
    var height: CGFloat? { get set }

    // MARK: - Tooltip container

    var borderRadius: CGFloat { get set }
    var borderRadiusStyle: RoundedCornerStyle { get set }
    var borderWidth: CGFloat { get set }
    var backgroundColor: Color { get set }

    // MARK: - Tooltip arrow

    var showArrow: Bool { get set }
    var arrowWidth: CGFloat { get set }
    var arrowHeight: CGFloat { get set }
    
    // MARK: - Animation settings
    var enableAnimation: Bool { get set }
    var animationOffset: CGFloat { get set }
    var animationTime: Double { get set }
    var animation: Optional<Animation> { get set }

    var transition: AnyTransition { get set }
}

public struct DefaultTooltipConfig: HiveToolTipConfig {
    static var shared = DefaultTooltipConfig()

    public var side: TooltipSide = .bottom
    public var margin: CGFloat = 8
    public var zIndex: Double = 10000
    
    public var width: CGFloat?
    public var height: CGFloat?

    public var borderRadius: CGFloat = 8
    public var borderRadiusStyle: RoundedCornerStyle = .circular
    public var borderWidth: CGFloat = 0
    public var backgroundColor: Color = Color(hex: "#262827")

    public var showArrow: Bool = true
    public var arrowWidth: CGFloat = 12
    public var arrowHeight: CGFloat = 6
    
    public var enableAnimation: Bool = false
    public var animationOffset: CGFloat = 10
    public var animationTime: Double = 1
    public var animation: Optional<Animation> = .easeInOut

    public var transition: AnyTransition = .opacity

    public init() {}

    public init(side: TooltipSide) {
        self.side = side
    }
}


public enum TooltipSide: Int {
    case left = 2
    case right = 6
    case top = 4
    case bottom = 0
    
    func getArrowAngleRadians() -> Optional<Double> {
        return Double(self.rawValue) * .pi / 4
    }
    
    func shouldShowArrow() -> Bool {
        return true
    }
}
