//
//  StaticView.swift
//  Bythen
//
//  Created by Ega Setya on 10/12/24.
//

import SwiftUI

struct StaticView: View {
    private var text: String
    private var closeAction: (() -> Void)? = nil
    
    init(text: String, closeAction: (() -> Void)? = nil) {
        self.text = text
        self.closeAction = closeAction
    }

    var body: some View {
        HStack(spacing: 0) {
            Image("info.fill")
                .resizable()
                .renderingMode(.template)
                .frame(width: 20, height: 20)
                .foregroundStyle(.byteBlack)
                .padding(.leading, 16)
            Text(text)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.byteBlack)
                .font(FontStyle.neueMontreal(size: 12.0))
                .lineSpacing(4)
                .padding(.vertical, 16)
                .padding(.horizontal, 16)
            
            Color.byteBlack.opacity(0.1)
                .frame(maxWidth: 1)
                .padding(.vertical, 8)
            
            Button(action: handleCloseTapped) {
                Image("close")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 11, height: 11)
                    .foregroundStyle(.byteBlack)
                    .padding(24)
            }
        }
        .background(Color.gokuOrange100)
    }
    
    private func handleCloseTapped() {
        closeAction?()
    }
}
