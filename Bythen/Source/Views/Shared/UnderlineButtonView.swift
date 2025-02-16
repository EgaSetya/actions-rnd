//
//  UnderlineButtonView.swift
//  Bythen
//
//  Created by edisurata on 31/08/24.
//

import SwiftUI

struct UnderlineButtonView: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(title)
                .foregroundColor(.black)
                .underline()
                .font(FontStyle.foundersGrotesk(.semibold, size: 16))
        }
    }
}

#Preview {
    UnderlineButtonView(title: "Hello", action: {})
}
