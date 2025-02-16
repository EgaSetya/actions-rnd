//
//  DojoStudioFooterView.swift
//  Bythen
//
//  Created by Darindra R on 31/10/24.
//

import SwiftUI

enum DojoStudioFooterViewAction {
    case bytes
    case emotion
    case ratio
    case speed
    case dojo
    case background
}

struct DojoStudioFooterView: View {
    let byte: Byte
    var action: (DojoStudioFooterViewAction) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 0) {
                Button {
                    action(.bytes)
                } label: {
                    VStack(spacing: 8) {
                        AsyncImage(url: URL(string: byte.byteData.byteImage.thumbnailUrl)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .frame(width: 56, height: 56)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle().stroke(.ghostWhite300, lineWidth: 1)
                                    )
                            } else {
                                Circle()
                                    .foregroundStyle(Color(hex: "#C5D6F8"))
                                    .frame(width: 56, height: 56)
                                    .overlay(alignment: .center) {
                                        ProgressView()
                                    }
                            }
                        }
                        .overlay(alignment: .bottomTrailing) {
                            Image(AppImages.kRefreshIcon)
                                .resizable()
                                .frame(width: 14, height: 14)
                                .padding(.all, 4)
                                .background(.black)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(.ghostWhite300, lineWidth: 1))
                                .offset(y: 4)
                        }

                        Text("Bytes")
                            .font(FontStyle.neueMontreal(.regular, size: 16))
                            .foregroundStyle(.white)
                    }
                }
                .frame(width: 88)

                DojoStudioButton(
                    title: "Emotion",
                    image: "face-smile-plus.sharp.solid",
                    isSelected: false
                ) {
                    action(.emotion)
                }
                .frame(width: 88)

                DojoStudioButton(
                    title: "Aspect Ratio",
                    image: "aspect-ratio-icon",
                    isSelected: false
                ) {
                    action(.ratio)
                }
                .frame(width: 88)

                DojoStudioButton(
                    title: "Speed",
                    image: "gauge-high.sharp.solid",
                    isSelected: false
                ) {
                    action(.speed)
                }
                .frame(width: 88)

                DojoStudioButton(
                    title: "Dojo",
                    image: "account-balance.fill",
                    isSelected: false
                ) {
                    action(.dojo)
                }
                .frame(width: 88)
            }
            .padding(.vertical, 21)
            .padding(.horizontal, 16)
        }
        .background(.byteBlack)
    }
}
