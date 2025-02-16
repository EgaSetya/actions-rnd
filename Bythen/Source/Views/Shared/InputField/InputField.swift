//
//  TextField.swift
//  Bythen
//
//  Created by Ega Setya on 10/12/24.
//

import SwiftUI

struct InputField<Content>: View where Content: View {
    private let content: Content
    
    var body: some View {
        content
    }
}

extension InputField where Content == BasicTextField {
    static func basic(text: Binding<String>, placeholder: String, errorText: Binding<String>) -> some View {
        Self(content: BasicTextField(text: text, errorText: errorText, placeholder: placeholder))
    }
}

extension InputField where Content == DisabledTextField {
    static func disabled(text: String, type: DisabledTextFieldType) -> some View {
        Self(content: DisabledTextField(text: text, type: type))
    }
}

struct CustomTextFieldPreview: View {
    @State private var text = ""
    @State private var errorText = ""
    
    var body: some View {
        VStack {
            InputField.basic(text: $text, placeholder: "Test", errorText: $errorText)
                .padding()
            
            Button("Toggle Error") {
                if errorText.isTrulyEmpty {
                    errorText = "This is error message"
                } else {
                    errorText = ""
                }
            }.padding()
            
            InputField.disabled(text: "Otep", type: .checked)
                .padding()
        }
    }
}

#Preview {
    CustomTextFieldPreview()
}
