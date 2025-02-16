//
//  FormSectionContainer.swift
//  Bythen
//
//  Created by Ega Setya on 11/12/24.
//

import SwiftUI

struct FormSectionContainer<Content>: View where Content: View {
    var title: String
    var subtitle: String = ""
    private var content: Content
    
    private let titleFont = FontStyle.neueMontreal(.medium, size: 20)
    private let subtitleFont = FontStyle.neueMontreal(.regular, size: 14)
    
    init(title: String, subtitle: String = "", @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(titleFont)
                .padding(.bottom, 4)
            
            if !subtitle.isTrulyEmpty {
                Text(subtitle)
                    .font(subtitleFont)
                    .foregroundStyle(.byteBlack.opacity(0.7))
                    .padding(.bottom, 4)
            }
            
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 16)
        .padding(.horizontal, 16)
    }
}


