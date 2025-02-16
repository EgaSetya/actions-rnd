//
//  CircularButton.swift
//  Bythen
//
//  Created by edisurata on 14/09/24.
//

import SwiftUI

struct CircularButton: View {
    
    var imageName: String
    var backgroundColor: Color = .white
    var isEnableTint: Bool = false
    var tintColor: Color = .clear
    var action: () -> Void = {}
    
    var body: some View {
        Button(action: action, label: {
            if isEnableTint {
                Image(uiImage: UIImage(named: imageName)!.withRenderingMode(.alwaysTemplate))
                    .resizable()
                    .padding(12)
                    .tint(tintColor)
            } else {
                Image(imageName)
                    .resizable()
                    .padding(12)
            }
        })
        .background(backgroundColor)
        .clipShape(Circle())
    }
}

#Preview {
    VStack {
        CircularButton(
            imageName: "pen.sharp.solid",
            backgroundColor: .gray.opacity(0.3),
            isEnableTint: true,
            tintColor: .red
        )
        .frame(maxWidth: 50, maxHeight: 50)
        .padding()
    }
    .background(.green)
}
