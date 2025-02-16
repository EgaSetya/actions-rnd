//
//  DisabledTextField.swift
//  Bythen
//
//  Created by Ega Setya on 11/12/24.
//

import SwiftUI

enum DisabledTextFieldType {
    case `default`
    case checked
}

struct DisabledTextField: View {
    var text: String
    var type: DisabledTextFieldType = .default
    
    var body: some View {
        ZStack(alignment: .trailing) {
            BaseTextField(text: .constant(text))
                .background {
                    TextFieldBackground(type: .constant(.disabled))
                }
                .disabled(true)
            
            if type == .checked {
                Image("upload-success-check")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22)
                    .padding(.trailing, 16)
            }
        }
    }
}
