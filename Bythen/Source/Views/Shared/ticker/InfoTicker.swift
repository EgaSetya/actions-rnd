//
//  InfoTicker.swift
//  Bythen
//
//  Created by edisurata on 13/11/24.
//

import SwiftUI

struct InfoTicker: View {
    
    @State var text: String
    @State var backgroundColor: Color
    var closeAction: (() -> Void)?
    var tapAction: (() -> Void)?
    
    var body: some View {
        HStack {
            Image("info.fill")
                .resizable()
                .renderingMode(.template)
                .frame(width: 20, height: 20)
                .foregroundStyle(.byteBlack)
                .padding(12)
                .padding(8)
            Text(text)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.byteBlack)
                .font(FontStyle.neueMontreal(size: 12))
                .lineSpacing(4)
                .padding(.vertical, 6)
                .padding(.vertical, 5)
            
            Color.byteBlack.opacity(0.1)
                .frame(maxWidth: 1)
                .padding(.vertical, 8)
            
            Button {
                if let action = closeAction {
                    action()
                }
            } label: {
                Image("close")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 11, height: 11)
                    .foregroundStyle(.byteBlack)
                    .padding(24)
            }

        }
        .frame(maxWidth: .infinity, maxHeight: 69)
        .background(backgroundColor)
        .onTapGesture {
            if let action = tapAction {
                action()
            }
        }
    }
}

#Preview {
    InfoTicker(text: "Hello", backgroundColor: .gokuOrange100)
}
