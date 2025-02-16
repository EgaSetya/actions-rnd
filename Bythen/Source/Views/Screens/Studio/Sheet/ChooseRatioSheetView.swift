//
//  ChooseRatioSheetView.swift
//  Bythen
//
//  Created by Darindra R on 11/12/24.
//

import SwiftUI

enum AspectRatio: String {
    case potrait = "9:16"
    case landscape = "16:9"
}

struct ChooseRatioSheetView: View {
    let initialRatio: AspectRatio
    let onSelectRatio: (AspectRatio) -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center) {
                Text("ASPECT RATIOS")
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

            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        DojoStudioButton(
                            title: "9:16",
                            image: "ratio-potrait-icon",
                            isSelected: initialRatio == .potrait
                        ) {
                            onSelectRatio(.potrait)
                        }
                        .id("9:16")

                        DojoStudioButton(
                            title: "16:9",
                            image: "ratio-landscape-icon",
                            isSelected: initialRatio == .landscape
                        ) {
                            onSelectRatio(.landscape)
                        }
                        .id("16:9")
                    }
                    .padding(.all, 16)
                    .onAppear {
                        scrollProxy.scrollTo(initialRatio.rawValue)
                    }
                }
            }
        }
        .background(.byteBlack)
        .cornerRadius(8, corners: [.topLeft, .topRight])
    }
}
