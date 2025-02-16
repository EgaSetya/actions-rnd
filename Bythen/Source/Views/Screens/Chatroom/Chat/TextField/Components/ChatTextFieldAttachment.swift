//
//  ChatTextFieldAttachment.swift
//  Bythen
//
//  Created by Darindra R on 30/09/24.
//

import SwiftUI

struct ChatTextFieldAttachment: View {
    var data: Attachment
    var didTapClose: () -> Void

    var body: some View {
        switch data.type {
        case let .image(image):
            Image(uiImage: image!)
                .resizable()
                .scaledToFill()
                .frame(width: 56, height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(alignment: .topTrailing) {
                    closeButton
                }
                .padding([.top, .horizontal], 8)
                .clipped()
        default:
            HStack(spacing: 8) {
                Image(data.type.icon)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 0) {
                    Text(data.fileName)
                        .font(FontStyle.neueMontreal(.medium, size: 14))
                        .lineLimit(1)

                    Text(data.type.rawValue)
                        .font(FontStyle.neueMontreal(.regular, size: 12))
                        .foregroundStyle(.appBlack.opacity(0.5))
                }

                Spacer()
            }
            .padding(.all, 8)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.appBlack.opacity(0.1), lineWidth: 1)
            )
            .overlay(alignment: .topTrailing) {
                closeButton
            }
            .padding([.top, .horizontal], 8)
        }
    }

    var closeButton: some View {
        Button {
            didTapClose()
        }
        label: {
            Image("close")
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(.byteBlack)
                .frame(width: 8, height: 8)
                .padding(.all, 8)
                .background(Color(hex: "#F5F3F0"))
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(.appBlack, lineWidth: 1)
                )
        }
        .offset(x: 8, y: -8)
    }
}
