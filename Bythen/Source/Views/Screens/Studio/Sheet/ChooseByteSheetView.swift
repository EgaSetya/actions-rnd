//
//  ChooseByteSheetView.swift
//  Bythen
//
//  Created by Darindra R on 11/11/24.
//

import SwiftUI

struct ChooseByteSheetView: View {
    let bytes: [Byte]
    let initialByte: Byte
    let onSelectByte: (Byte) -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center) {
                Text("CHOOSE BYTES")
                    .font(FontStyle.foundersGrotesk(.semibold, size: 20))
                    .foregroundStyle(.white)

                Spacer()

                Button(
                    action: {
                        onCancel()
                    }
                ) {
                    Image(systemName: "xmark")
                        .frame(width: 24, height: 24)
                }
                .tint(.white)
            }
            .padding([.top, .horizontal], 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(bytes) { byte in
                        VStack(spacing: 8) {
                            AsyncImage(url: URL(string: byte.byteData.byteImage.thumbnailUrl)) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .frame(width: 56, height: 56)
                                        .clipShape(Circle())
                                        .overlay {
                                            if initialByte.buildID == byte.buildID {
                                                Circle().stroke(.white, lineWidth: 3)
                                            }
                                        }
                                } else {
                                    Circle()
                                        .foregroundStyle(Color(hex: "#C5D6F8"))
                                        .frame(width: 56, height: 56)
                                        .overlay(alignment: .center) {
                                            ProgressView()
                                        }
                                }
                            }

                            Text(byte.byteName)
                                .font(FontStyle.neueMontreal(.regular, size: 12))
                                .foregroundStyle(.white)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .frame(maxWidth: 60)
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 1)) {
                                onSelectByte(byte)
                            }
                        }
                    }
                }
                .padding(.all, 16)
            }
        }
        .background(.byteBlack)
        .cornerRadius(8, corners: [.topLeft, .topRight])
    }
}
