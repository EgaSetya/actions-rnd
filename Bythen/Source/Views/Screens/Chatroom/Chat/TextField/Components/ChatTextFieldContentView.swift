//
//  ChatTextFieldContentView.swift
//  Bythen
//
//  Created by Darindra R on 30/09/24.
//

import SwiftUI

struct ChatTextFieldContentView: View {
    @ObservedObject
    var viewModel: ChatTextFieldViewModel

    @State
    private var textViewHeight: CGFloat = .zero

    var body: some View {
        if viewModel.isRecording {
            HStack(spacing: 8) {
                Text(viewModel.elapsedTimeString)
                    .font(FontStyle.neueMontreal(.regular, size: 14))
                    .frame(width: 40)

                HStack(spacing: 2) {
                    ForEach(0 ..< viewModel.animateDots.count, id: \.self) { idx in
                        Circle()
                            .fill(.appBlack)
                            .frame(width: 6, height: 6)
                            .scaleEffect(x: 1.0, y: 1.0 + viewModel.voicePower[idx] * 2)
                            .animation(Animation.easeInOut, value: viewModel.voicePower)
                    }
                }

                Spacer()
            }
            .frame(height: 33)
            .padding(.leading, 8)

        } else {
            ZStack(alignment: .leading) {
                if viewModel.isLoading {
                    HStack {
                        ThreeDotsLoader()
                        Spacer()
                    }
                    .frame(height: 33)
                    .padding(.leading, 8)
                } else {
                    Text("Write a message...")
                        .font(FontStyle.neueMontreal(.regular, size: 14))
                        .padding(.leading, 8)
                        .foregroundColor(Color(hex: "#8A8378"))
                        .opacity(viewModel.text.isEmpty ? 1 : 0)
                }

                GrowingTextEditor(
                    text: $viewModel.text,
                    height: $textViewHeight,
                    isFocused: $viewModel.isFocused
                )
                .frame(height: textViewHeight)
                .disabled(viewModel.isLoading)
            }
        }
    }
}
