//
//  BackstoryChatBubble.swift
//  Bythen
//
//  Created by Darindra R on 22/10/24.
//

import SwiftUI

struct BackstoryChatBubble: View {
    let index: Int

    @ObservedObject
    var viewModel: BackstoryViewModel

    private var chat: ChatHistory {
        viewModel.chat[index]
    }

    private var shouldEnableFooter: Bool {
        let isLastMessage = viewModel.chat.count == index + 1
        return isLastMessage && viewModel.isFinished
    }

    var body: some View {
        switch chat.role {
        case .initial:
            HStack(alignment: .center, spacing: 16) {
                Image("sparkles")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .padding(7)
                    .background(Circle().stroke(.byteBlack.opacity(0.1), lineWidth: 1))
                    .padding(.top, 12)

                ThreeDotsLoader()
                    .padding(.top, 12)
                Spacer(minLength: 0)
            }

        case .assistant:
            VStack(spacing: 12) {
                HStack(alignment: .top, spacing: 12) {
                    Image("sparkles")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .padding(7)
                        .background(Circle().stroke(.byteBlack.opacity(0.1), lineWidth: 1))
                        .padding(.top, 12)
                        

                    Text(chat.content)
                        .textSelection(.enabled)
                        .font(FontStyle.secondFont(.regular, size: 16))
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                        .background(.appBlack.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 24))

                    Spacer(minLength: 0)
                }

                if shouldEnableFooter {
                    HStack(alignment: .center, spacing: 12) {
                        Spacer()

                        Button(
                            action: {
                                Task {
                                    await viewModel.didSaveDescription(chat.content)
                                }
                            }
                        ) {
                            Text("SAVE DESCRIPTION")
                                .font(FontStyle.firstFont(.semibold, size: 14))
                                .foregroundStyle(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 16)
                                .background(.appBlack)
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                        }

                        Button(
                            action: {
                                Task {
                                    await viewModel.didRegenerateChat()
                                }
                            }
                        ) {
                            Image(AppImages.kRegenerateIco)
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(.all, 4)
                        }
                    }
                }
            }

        case .user:
            HStack {
                Spacer()
                Text(chat.content)
                    .textSelection(.enabled)
                    .font(FontStyle.secondFont(.regular, size: 16))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color(hex: "#C5D6F8"))
                    .clipShape(
                        RoundedCornersShape(
                            corners: [.topLeft, .bottomLeft, .topRight],
                            radius: 24
                        )
                    )
            }
        }
    }
}
