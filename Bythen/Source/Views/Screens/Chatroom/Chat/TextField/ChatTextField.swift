//
//  ChatTextField.swift
//  Bythen
//
//  Created by Darindra R on 21/09/24.
//

import SwiftUI

struct ChatTextField: View {
    @EnvironmentObject
    var mainState: MainViewModel

    @ObservedObject
    var viewModel: ChatTextFieldViewModel

    @State private var isAnimating: Bool = false

    init(_ viewModel: ChatTextFieldViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let attachment = viewModel.attachment {
                ChatTextFieldAttachment(data: attachment) {
                    viewModel.attachment = nil
                }
            }

            HStack(alignment: viewModel.isRecording ? .center : .bottom, spacing: 4) {
                ChatTextFieldContentView(viewModel: viewModel)
                ChatTextFieldButton(viewModel: viewModel)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 24).stroke(Color.black, lineWidth: 1)
        )
        .onAppear {
            viewModel.setMainState(state: mainState)
        }
    }
}
