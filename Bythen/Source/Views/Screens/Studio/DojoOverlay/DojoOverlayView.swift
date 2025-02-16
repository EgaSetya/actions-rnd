//
//  DojoOverlayView.swift
//  Bythen
//
//  Created by Darindra R on 31/10/24.
//

import SwiftUI

struct DojoOverlayView: View {
    @Binding var isPlaying: Bool
    @Binding var enableChangeBg: Bool
    @Binding var isAssetReady: Bool
    @Binding var showCaptions: Bool

    @State var showAssetNotReadyTicker: Bool = true

    let script: String
    let showScriptButton: Bool
    let onPressChangeBg: () -> Void
    let onPressPlayButton: () -> Void
    let onPressAddScript: () -> Void
    let onPressCaption: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()

                if enableChangeBg {
                    Button {
                        onPressChangeBg()
                    } label: {
                        Image("photo-library.fill")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(.white)
                            .frame(width: 20, height: 20)
                            .padding(.all, 12)
                    }
                    .foregroundStyle(.white)
                    .background(.black)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(.ghostWhite300, lineWidth: 1)
                    )
                    
                    if !script.isEmpty {
                        Button {
                            onPressCaption()
                        } label: {
                            Image("closed-caption")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundStyle(showCaptions ? .white : .white.opacity(0.5))
                                .frame(width: 18, height: 14)
                                .padding(.all, 12)
                                .padding(.vertical, 3)
                                .padding(.horizontal, 1)
                        }
                        .foregroundStyle(.white)
                        .background(.black)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(.ghostWhite300, lineWidth: 1)
                        )
                    }
                }
            }
            .frame(height: 44)
            .overlay(alignment: .center) {
                if !isAssetReady, showAssetNotReadyTicker {
                    HStack {
                        Image("info.fill")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.byteBlack)
                            .padding(12)
                            .padding(8)
                        Text("Your bytes is still in the making. Please use the default bytes for now")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.byteBlack)
                            .font(FontStyle.neueMontreal(size: 12))
                            .lineSpacing(4)
                            .padding(.vertical, 6)
                            .padding(.vertical, 5)

                        Color.byteBlack.opacity(0.1)
                            .frame(maxWidth: 1)
                            .padding(.vertical, 8)

                        Button {
                            showAssetNotReadyTicker = false
                        } label: {
                            Image("close")
                                .resizable()
                                .frame(width: 11, height: 11)
                                .foregroundStyle(.byteBlack)
                                .padding(24)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 69)
                    .background(.sonicBlue300)
                    .padding(.top, 16)
                } else {
                    if showScriptButton && script.isEmpty {
                        HStack(alignment: .center, spacing: 8) {
                            Image(AppImages.kDragIcon)
                                .resizable()
                                .frame(width: 20, height: 20)

                            Text("Scroll and drag to position Byte")
                                .font(FontStyle.neueMontreal(.regular, size: 12))
                                .foregroundStyle(.white)
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal, 16)
                        .background(.appBlack.opacity(0.7))
                        .clipShape(RoundedRectangle(cornerRadius: 100))
                    }
                }
            }
            .padding([.top, .horizontal], 16)

            Spacer()

            if showScriptButton {
                if script.isNotEmpty, !isPlaying {
                    Button(
                        action: {
                            onPressPlayButton()
                        },
                        label: {
                            Image(systemName: "play.fill")
                                .font(.system(size: 32))
                                .foregroundStyle(.white)
                                .padding(.all, 18)
                                .background(.appBlack.opacity(0.7))
                                .clipShape(Circle())
                        }
                    )

                    Spacer()
                }

                Button {
                    onPressAddScript()
                } label: {
                    HStack(spacing: 8) {
                        if script.isEmpty {
                            Image(systemName: "plus")
                                .frame(width: 20, height: 20)
                                .foregroundStyle(.white)

                            Text("ADD SCRIPT")
                                .font(FontStyle.foundersGrotesk(.semibold, size: 16))
                                .foregroundStyle(.white)
                        } else {
                            Image("edit-pencil-fill")
                                .resizable()
                                .frame(width: 20, height: 20)

                            Text("EDIT SCRIPT")
                                .font(FontStyle.foundersGrotesk(.semibold, size: 16))
                                .foregroundStyle(.white)
                        }
                    }
                }
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
                .background(.black)
                .clipShape(RoundedRectangle(cornerRadius: 100))
                .overlay(
                    RoundedRectangle(cornerRadius: 100)
                        .stroke(.ghostWhite300, lineWidth: 1)
                )
                .padding(.bottom, 16)

                if script.isNotEmpty {
                    ScrollView {
                        Text(script)
                            .font(.neueMontreal(size: 18))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxHeight: 100)
                    .padding(.all, 8)
                    .background(.appBlack.opacity(0.7))
                }
            }
        }
        .background(.clear)
    }
}
