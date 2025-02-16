//
//  BasicButton.swift
//  Bythen
//
//  Created by Ega Setya on 12/12/24.
//

import SwiftUI

enum BasicButtonType {
    case rectangle
    case rounded
    case rectangleBordered
}

struct AnyShape: Shape {
    private let _path: (CGRect) -> Path

    init<S: Shape>(_ shape: S) {
        _path = { rect in
            shape.path(in: rect)
        }
    }

    func path(in rect: CGRect) -> Path {
        _path(rect)
    }
}

struct BasicButton: View {
    var type: BasicButtonType
    var title: String
    var colorScheme: ColorScheme
    var foregroundColor: Color?
    var backgroundColor: Color?
    @Binding var isDisabled: Bool
    var onTap: (() -> Void)
    
    private let font  = FontStyle.foundersGrotesk(.semibold, size: 16)
    
    private var _foregroundColor: Color {
        if colorScheme == .dark {
            return isDisabled ? .byteBlack.opacity(0.3) : .byteBlack
        }
        
        return isDisabled ? .byteBlack.opacity(0.3) : .white
    }
    
    private var _backgroundColor: Color {
        if colorScheme == .dark {
            return isDisabled ? .white.opacity(0.1) : .white
        }
        
        return isDisabled ? .byteBlack.opacity(0.1) : .byteBlack
    }
    
    var body: some View {
        Button(action: {
            onTap()
        }) {
            Text(title)
                .font(font)
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity)
                .background(backgroundColor ?? _backgroundColor)
                .foregroundColor(foregroundColor ?? _foregroundColor)
                .clipShape(configureClipShape())
        }
        .conditionalModifier(type == .rectangleBordered) { view in
            view.background(
                Rectangle().stroke(Color.byteBlack800.opacity(0.7), lineWidth: 1)
            )
        }
        .disabled(isDisabled)
    }
    
    private func configureClipShape() -> some Shape {
        type == .rounded ? AnyShape(Capsule()) : AnyShape(Rectangle())
    }
}
