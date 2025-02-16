//
//  ByteToggleButton.swift
//  Bythen
//
//  Created by Darindra R on 19/09/24.
//

import SwiftUI

protocol ByteToggleButtonStyleConfig {
    var labelText: String { get }
    var labelFont: Font { get }
    var offLabelColor: Color { get }
    var onLabelColor: Color { get }
    var circleSize: CGFloat { get }
    var iconSize: CGFloat { get }
    var offBackgroundColor: Color { get }
    var onBackgroundColor: Color { get }
    var icon: ByteToggleButtonIcon { get }
    var offIconColor: Color { get }
    var onIconColor: Color { get }
}

enum ByteToggleButtonIcon {
    case system(systemName: String)
    case image(name: String)
}

struct ByteToggleButton: View {
    @Binding
    private var isOn: Bool
    private var style: ByteToggleButtonStyleConfig = ByteStyle()

    init(isOn: Binding<Bool>) {
        _isOn = isOn
    }

    var body: some View {
        HStack {
            if isOn {
                Text(style.labelText)
                    .font(style.labelFont)
                    .foregroundStyle(style.onLabelColor)
                    .transition(.opacity)
            }

            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: style.circleSize, height: style.circleSize)

                switch style.icon {
                case let .system(name):
                    Image(systemName: name)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(isOn ? style.onIconColor : style.offIconColor)
                        .frame(width: style.iconSize, height: style.iconSize)
                case let .image(name):
                    Image(name)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(isOn ? style.onIconColor : style.offIconColor)
                        .frame(width: style.iconSize, height: style.iconSize)
                }
            }
            .animation(.easeInOut(duration: 0.15), value: isOn)

            if !isOn {
                Text(style.labelText)
                    .font(style.labelFont)
                    .foregroundStyle(style.offLabelColor)
                    .transition(.opacity)
            }
        }
        .padding(.vertical, 4)
        .padding(.leading, isOn ? 8 : 4)
        .padding(.trailing, isOn ? 4 : 8)
        .background {
            RoundedRectangle(cornerRadius: 25)
                .fill(isOn ? style.onBackgroundColor : style.offBackgroundColor)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        isOn.toggle()
                    }
                }
        }
    }
}

extension ByteToggleButton {
    public func style(_ style: ByteToggleButtonStyleConfig) -> Self {
        var newSelf = self
        newSelf.style = style
        return newSelf
    }
}

/// Default style configurations
struct ByteStyle: ByteToggleButtonStyleConfig {
    var labelText: String { "BYTE" }
    var labelFont: Font { FontStyle.firstFont(.semibold, size: 11) }
    var offLabelColor: Color { .appBlack.opacity(0.5) }
    var onLabelColor: Color { .white }
    var circleSize: CGFloat { 28 }
    var iconSize: CGFloat { 16 }
    var offBackgroundColor: Color { .appBlack.opacity(0.1) }
    var onBackgroundColor: Color { .appBlack }
    var icon: ByteToggleButtonIcon { .system(systemName: "eye") }
    var offIconColor: Color { .appBlack.opacity(0.5) }
    var onIconColor: Color { .appBlack }
}

struct AiModeStyle: ByteToggleButtonStyleConfig {
    var labelText: String { "AI MODE" }
    var labelFont: Font { FontStyle.firstFont(.semibold, size: 9) }
    var offLabelColor: Color { .appBlack.opacity(0) }
    var onLabelColor: Color { .white }
    var circleSize: CGFloat { 20 }
    var iconSize: CGFloat { 10 }
    var offBackgroundColor: Color { .appBlack.opacity(0.1) }
    var onBackgroundColor: Color { Color(hex: "#F04406") }
    var icon: ByteToggleButtonIcon { .image(name: "sparkles") }
    var offIconColor: Color { .appBlack.opacity(0.5) }
    var onIconColor: Color { Color(hex: "#F04406") }
}
