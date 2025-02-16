//
//  ChatEmptyStateView.swift
//  Bythen
//
//  Created by Darindra R on 25/09/24.
//

import SwiftUI

struct ChatEmptyStateView: View {
    @State
    private var minHeight: CGFloat = 0
    private let columns = [
        GridItem(.fixed(164)),
        GridItem(.fixed(164)),
    ]

    var byte: ByteBuild
    var didSelectTemplate: (String) -> Void

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            VStack(alignment: .center, spacing: 8) {
                let imageURL = URL(string: byte.byteData.byteImage.thumbnailUrl)
                AsyncImage(url: imageURL) { image in
                    if let image = image.image {
                        image
                            .resizable()
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .foregroundStyle(Color(hex: "#C5D6F8"))
                            .frame(width: 64, height: 64)
                    }
                }

                Text(byte.byteName)
                    .font(FontStyle.neueMontreal(.medium, size: 20))

                Text(byte.role)
                    .font(FontStyle.neueMontreal(.regular, size: 12))
                    .foregroundStyle(.appBlack.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            .padding(.all, 20)

            LazyVGrid(columns: columns, alignment: .center, spacing: 8) {
                ForEach(byte.starterChats, id: \.self) { chat in
                    Text(chat.text)
                        .font(FontStyle.neueMontreal(.medium, size: 14))
                        .padding(.all, 12)
                        .frame(maxWidth: .infinity, minHeight: minHeight)
                        .background(Color(hex: "#C5D6F8"))
                        .background(Rectangle().stroke(Color.black, lineWidth: 1))
                        .overlay {
                            GeometryReader { proxy in
                                Color.clear
                                    .onFirstAppear {
                                        if proxy.size.height > minHeight {
                                            minHeight = proxy.size.height
                                        }
                                    }
                            }
                        }
                        .onTapGesture {
                            didSelectTemplate(chat.text)
                        }
                }
            }
            .padding(.all, 20)
        }
    }
}
