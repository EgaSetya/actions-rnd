//
//  ByteChip.swift
//  Bythen
//
//  Created by erlina ng on 21/10/24.
//

import SwiftUI

struct ByteChip: View {
    private var text: String
    private var onTap: (() -> Void)?
    
    init(text: String, onTap: (() -> Void)?) {
        self.text = text
        self.onTap = onTap
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Text(text)
                .font(FontStyle.foundersGrotesk(.medium, size: 14))
            
            Image(systemName: "xmark")
                .frame(width: 16, height: 16)
        }
        .padding(.vertical, 12)
        .padding(.trailing, 14)
        .padding(.leading, 20)
        .background {
            RoundedRectangle(cornerRadius: 100)
                .fill(Color.gokuOrange300)
                .onTapGesture {
                    withAnimation {
                        onTap?()
                    }
                }
        }
    }
}
