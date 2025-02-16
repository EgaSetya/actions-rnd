//
//  TextIconButton.swift
//  Bythen
//
//  Created by Ega Setya on 12/12/24.
//

import SwiftUI

enum TextIconButtonType {
    case left(name: String)
    case right(name: String)
}

struct TextIconButton: View {
    var type: TextIconButtonType
    var title: String
    var font: Font?
    var colorScheme: ColorScheme
    var fillWidth: Bool = false
    var enabledBackgroundColor: Color?
    @Binding var isDisabled: Bool
    var onTap: (() -> Void)
    
    private var _font: Font {
        switch type {
        case .left: FontStyle.foundersGrotesk(.semibold, size: 12)
        case .right: FontStyle.dmMono(.regular, size: 12)
        }
    }
    
    private var iconName: String {
        switch type {
        case .left(let name), .right(let name):
            name
        }
    }
    
    private var foregroundColor: Color {
        if colorScheme == .dark {
            return isDisabled ? .byteBlack.opacity(0.3) : .byteBlack
        }
        
        return isDisabled ? .byteBlack.opacity(0.3) : .white
    }
    
    private var backgroundColor: Color {
        let _enabledColor = colorScheme == .dark ? (enabledBackgroundColor ?? .white) : .byteBlack
        let _disabledColor = colorScheme == .dark ? Color.white.opacity(0.1) : .byteBlack.opacity(0.1)
        
        return isDisabled ? _disabledColor : _enabledColor
    }
    
    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 8) {
                if case .left = type {
                    Image(iconName)
                        .frame(square: 16)
                }
                
                Text(title)
                    .font(font ?? _font)
                    .frame(height: 32)
                
                if case .right = type {
                    Image(iconName)
                        .frame(square: 16)
                }
            }
            .conditionalModifier(fillWidth) { view in
                view
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity)
            }
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .contentShape(Rectangle())
        }
        .disabled(isDisabled)
    }
}
