//
//  TextFieldBackground.swift
//  Bythen
//
//  Created by Ega Setya on 11/12/24.
//

import SwiftUI

enum TextFieldBackgroundType {
    case `default`
    case focused
    case disabled
    case error
}

struct TextFieldBackground: View {
    @Binding var type: TextFieldBackgroundType
    
    private let lineWidth: CGFloat = 1
    
    private var backgroundColor: Color {
        switch type {
        case .disabled: .appBlack.opacity(0.05)
        default: .white
        }
    }
    
    private var strokeColor: Color {
        switch type {
        case .default: .appBlack.opacity(0.3)
        case .focused: .appBlack
        case .disabled: .appBlack.opacity(0.1)
        case .error: .elmoRed500
        }
    }
    
    
    var body: some View {
        Rectangle()
            .stroke(strokeColor, lineWidth: lineWidth)
            .background(backgroundColor)
    }
}
