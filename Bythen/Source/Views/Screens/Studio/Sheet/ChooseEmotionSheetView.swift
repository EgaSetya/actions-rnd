//
//  ChooseEmotionSheetView.swift
//  Bythen
//
//  Created by Darindra R on 11/11/24.
//

import SwiftUI

struct ChooseEmotionSheetView: View {
    let initialEmotion: String
    let onSelectEmotion: (String) -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center) {
                Text("EMOTIONS")
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
                            title: "Neutral",
                            image: AppImages.kEmotionNeutralIcon,
                            isSelected: initialEmotion.lowercased() == "neutral"
                        ) {
                            onSelectEmotion("Neutral")
                        }
                        .id("Neutral")

                        DojoStudioButton(
                            title: "Enthusiastic",
                            image: AppImages.kEmotionEnthusiasIcon,
                            isSelected: initialEmotion.lowercased() == "enthusiastic"
                        ) {
                            onSelectEmotion("Enthusiastic")
                        }
                        .id("Enthusiastic")

                        DojoStudioButton(
                            title: "Joy",
                            image: AppImages.kEmotionJoyIcon,
                            isSelected: initialEmotion.lowercased() == "joy"
                        ) {
                            onSelectEmotion("Joy")
                        }
                        .id("Joy")

                        DojoStudioButton(
                            title: "Sadness",
                            image: AppImages.kEmotionSadIcon,
                            isSelected: initialEmotion.lowercased() == "sadness"
                        ) {
                            onSelectEmotion("Sadness")
                        }
                        .id("Sadness")

                        DojoStudioButton(
                            title: "Trust",
                            image: AppImages.kEmotionTrustIcon,
                            isSelected: initialEmotion.lowercased() == "trust"
                        ) {
                            onSelectEmotion("Trust")
                        }
                        .id("Trust")

                        DojoStudioButton(
                            title: "Surprise",
                            image: AppImages.kEmotionSurpriseIcon,
                            isSelected: initialEmotion.lowercased() == "surprise"
                        ) {
                            onSelectEmotion("Surprise")
                        }
                        .id("Surprise")

                        DojoStudioButton(
                            title: "Anger",
                            image: AppImages.kEmotionAngerIcon,
                            isSelected: initialEmotion.lowercased() == "anger"
                        ) {
                            onSelectEmotion("Anger")
                        }
                        .id("Anger")

                        DojoStudioButton(
                            title: "Fear",
                            image: AppImages.kEmotionFearIcon,
                            isSelected: initialEmotion.lowercased() == "fear"
                        ) {
                            onSelectEmotion("Fear")
                        }
                        .id("Fear")

                        DojoStudioButton(
                            title: "Disgust",
                            image: AppImages.kEmotionDisgustIcon,
                            isSelected: initialEmotion.lowercased() == "disgust"
                        ) {
                            onSelectEmotion("Disgust")
                        }
                        .id("Disgust")
                    }
                    .padding(.all, 16)
                    .onAppear {
                        scrollProxy.scrollTo(initialEmotion)
                    }
                }
            }
        }
        .background(.byteBlack)
        .cornerRadius(8, corners: [.topLeft, .topRight])
    }
}
