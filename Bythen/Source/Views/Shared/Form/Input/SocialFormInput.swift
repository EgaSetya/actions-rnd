//
//  SocialFormInput.swift
//  Bythen
//
//  Created by Ega Setya on 12/12/24.
//

import SwiftUI

enum SocialFormInputType {
    case telegram
    case twitter
}

struct SocialFormInput: View {
    var type: SocialFormInputType
    @Binding var text: String
    
    private var configuration: (iconName: String, title: String, placeholder: String) {
        switch type {
        case .telegram:
            ("telegram-icon", "Telegram", "Enter username")
        case .twitter:
            ("twitter-icon", "Twitter", "Enter username")
        }
    }
    private let titleFont = FontStyle.neueMontreal(.medium, size: 18)
    
    var body: some View {
        HStack(alignment: .center) {
            Image(configuration.iconName)
                .frame(width: 24, height: 24)
            
            Text(configuration.title)
                .font(titleFont)
            
            Spacer()
            
            InputField.basic(text: $text, placeholder: configuration.placeholder, errorText: .constant(""))
                .frame(width: 203)
        }
        .padding(.vertical, 6)
    }
}
