//
//  FormInput.swift
//  Bythen
//
//  Created by Ega Setya on 12/12/24.
//

import SwiftUI

struct FormInput: View {
    var title: String
    @Binding var text: String
    var placeholder: String
    @Binding var errorText: String
    
    private let titleFont = FontStyle.neueMontreal(.medium, size: 16)
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(titleFont)
                .padding(.bottom, 8)
            
            InputField.basic(text: $text, placeholder: placeholder, errorText: $errorText)
        }
        .padding(.vertical, 12)
    }
}
