//
//  ChatTextFieldButton.swift
//  Bythen
//
//  Created by Darindra R on 30/09/24.
//

import SwiftUI

struct ChatTextFieldButton: View {
    @ObservedObject
    var viewModel: ChatTextFieldViewModel

    var body: some View {
        if viewModel.isRecording {
            Button {
                viewModel.stopRecording()
            }
            label: {
                Image(systemName: "stop.fill")
                    .frame(width: 16, height: 16)
                    .foregroundStyle(.white)
                    .padding(.all, 8)
                    .background(Circle().fill(.appBlack))
            }
        } else if viewModel.text.isEmpty {
            Button {
                viewModel.startRecording()
            }
            label: {
                Image(systemName: "mic.fill")
                    .frame(width: 16, height: 16)
                    .foregroundStyle(.appBlack.opacity(viewModel.isLoading || viewModel.isGeneratingResponse ? 0.3 : 1))
                    .padding(.all, 8)
            }
            .disabled(viewModel.isLoading || viewModel.isGeneratingResponse)

        } else {
            Button {
                viewModel.sendMessage()
            }
            label: {
                Image(systemName: "arrow.up")
                    .frame(width: 16, height: 16)
                    .foregroundStyle(.white)
                    .padding(.all, 8)
                    .background(Circle().fill(.appBlack.opacity(viewModel.text.isEmpty || viewModel.isGeneratingResponse ? 0.3 : 1)))
            }
            .disabled(viewModel.isGeneratingResponse)
        }
    }
}
