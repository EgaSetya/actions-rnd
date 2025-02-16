//
//  BasicBorderedSquareButton.swift
//  Bythen
//
//  Created by edisurata on 30/08/24.
//

import SwiftUI

struct BasicBorderedButton: View {
    var title: String
    var fontSize: CGFloat = 18
    var foregroundColor: Color = .appBlack
    var cornerRadius: CGFloat = 0
    var action: () -> Void = {}
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundStyle(foregroundColor)
                .frame(maxWidth: .infinity)
                .padding([.top, .bottom])
                .padding([.leading, .trailing], 10)
                .font(FontStyle.foundersGrotesk(.semibold, size: fontSize))
                
        }
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(foregroundColor, lineWidth: 1)
        )
    }
}

#Preview {
    BasicBorderedButton(title:"Basic Button", cornerRadius: 8, action: {})
        .padding()
}
