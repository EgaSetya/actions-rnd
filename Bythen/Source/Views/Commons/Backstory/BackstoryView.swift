//
//  BackstoryView.swift
//  Bythen
//
//  Created by Darindra R on 22/10/24.
//

import SwiftUI

struct BackstoryView: View {
    @Environment(\.dismiss)
    private var dismiss

    @EnvironmentObject
    var mainState: MainViewModel

    @StateObject
    var viewModel: BackstoryViewModel

    var onSaveContent: () -> Void

    var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(
                action: {
                    dismiss()
                }
            ) {
                Image(systemName: "xmark")
                    .frame(width: 24, height: 24)
            }
            .tint(.appBlack)

            HStack(alignment: .center) {
                Text("Backstory")
                    .font(FontStyle.foundersGrotesk(.medium, size: 28))
                    .foregroundColor(.black)

                Spacer()

                ByteToggleButton(isOn: $viewModel.isChatMode)
                    .style(AiModeStyle())
            }
        }
        .contentShape(Rectangle())
        .padding(.all, 16)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header

            if viewModel.isChatMode {
                ScrollViewReader { scrollProxy in
                    ScrollView {
                        VStack(spacing: 24) {
                            LazyVStack(alignment: .leading, spacing: 24) {
                                ForEach(viewModel.chat.indices, id: \.self) { index in
                                    BackstoryChatBubble(
                                        index: index,
                                        viewModel: viewModel
                                    )
                                }
                            }

                            Color.clear
                                .frame(height: 1)
                                .id("bottom_scroll_view")
                        }
                        .onChange(of: viewModel.chat) { _ in
                            withAnimation {
                                scrollProxy.scrollTo("bottom_scroll_view", anchor: .bottom)
                            }
                        }
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .scrollIndicators(.hidden)
                }

                ChatTextField(viewModel.textFieldVM)
                    .padding(.bottom, 24)
                    .padding([.top, .horizontal], 12)
                    .task {
                        await viewModel.bindTextFieldVM()
                    }

            } else {
                BackstoryDescriptionView(description: $viewModel.description) { description in
                    Task {
                        await viewModel.didSaveDescription(description)
                    }
                }
            }
        }
        .onAppear {
            viewModel.setMainState(state: mainState)
        }
        .onChange(of: viewModel.isDismissed) { isDismissed in
            if isDismissed {
                dismiss()
                onSaveContent()
            }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil,
                from: nil,
                for: nil
            )
        }
    }
}
