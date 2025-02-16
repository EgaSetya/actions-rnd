//
//  DojoStudioButton.swift
//  Bythen
//
//  Created by Darindra R on 30/10/24.
//

import SwiftUI

struct DojoStudioButton: View {
    let title: String
    let image: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            VStack(spacing: 8) {
                Image(image)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .foregroundStyle(.white)
                    .frame(width: 32, height: 32)
                    .padding(.all, 12)
                    .background(isSelected ? .gokuOrange600 : .appBlack)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(
                                isSelected ? .white : .ghostWhite300,
                                lineWidth: isSelected ? 3 : 1
                            )
                    )

                Text(title)
                    .font(FontStyle.neueMontreal(.regular, size: 14))
                    .foregroundStyle(.white)
            }
        }
    }
}
