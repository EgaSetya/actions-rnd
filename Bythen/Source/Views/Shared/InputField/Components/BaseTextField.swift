//
//  BaseTextField.swift
//  Bythen
//
//  Created by Ega Setya on 11/12/24.
//

import SwiftUI

struct BaseTextField: View {
    @Binding var text: String
    var placeholder: String = ""
    @FocusState var isFocused: Bool
    
    private let font: Font = FontStyle.neueMontreal(size: 18)
    private let horizontalPadding: CGFloat = 16
    private let verticalPadding: CGFloat = 12
    
    var body: some View {
        TextField(placeholder, text: $text)
            .font(font)
            .disableAutocorrection(true)
            .padding(.vertical, verticalPadding)
            .padding(.horizontal, horizontalPadding)
            .focused($isFocused, equals: true)
    }
}
