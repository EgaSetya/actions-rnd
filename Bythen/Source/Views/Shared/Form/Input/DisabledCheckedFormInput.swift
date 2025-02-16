//
//  DisabledCheckedFormInput.swift
//  Bythen
//
//  Created by Ega Setya on 12/12/24.
//

import SwiftUI

struct DisabledCheckedFormInput: View {
    var title: String
    var text: String
    
    private let titleFont = FontStyle.neueMontreal(.medium, size: 16)
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(titleFont)
                .padding(.bottom, 8)
            
            InputField.disabled(text: text, type: .checked)
        }
        .padding(.vertical, 12)
    }
}
