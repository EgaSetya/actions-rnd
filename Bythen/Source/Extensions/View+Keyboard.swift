//
//  View+Keyboard.swift
//  Bythen
//
//  Created by edisurata on 19/10/24.
//

import SwiftUI

extension View {
    func onKeyboardChange(perform action: @escaping (CGFloat) -> Void) -> some View {
        self.modifier(KeyboardAwareModifier(action: action))
    }
}

struct KeyboardAwareModifier: ViewModifier {
    @StateObject private var keyboardResponder = KeyboardResponder()
    
    var action: (CGFloat) -> Void

    func body(content: Content) -> some View {
        content
            .onChange(of: keyboardResponder.keyboardHeight) { newValue in
                action(newValue)
            }
    }
}
