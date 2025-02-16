//
//  DojoStudioView.swift
//  Bythen
//
//  Created by Darindra R on 29/10/24.
//

import SwiftUI

enum StudioNavigationPage: Hashable {
    case dojo
    case videoSaved
}

struct DojoStudioView: View {
    @EnvironmentObject
    var mainState: MainViewModel

    @EnvironmentObject
    var sideMenuState: SideMenuContentViewModel
    var navigateToChat: (Int64, String) -> Void

    @State
    private var path = NavigationPath()

    @StateObject
    private var viewModel = DojoStudioViewModel.new()

    var header: some View {
        HStack(alignment: .center) {
            SideMenuButton(sideMenuTheme: .dark).colorScheme(.dark)

            Spacer()

            if viewModel.isHasBuild {
                Button {
                    if viewModel.ratio == .landscape {
                        BythenAppDelegate.setViewOrientation(orientation: .landscape)
                        if viewModel.isEnableStudioRecordImprovement {
                            viewModel.prepareUnityPlayer(recording: true)
                        } else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                viewModel.startRecording()
                            }
                        }
                    } else {
                        if viewModel.isEnableStudioRecordImprovement {
                            viewModel.prepareUnityPlayer(recording: true)
                        } else {
                            viewModel.startRecording()
                        }
                    }
                    
                } label: {
                    HStack(spacing: 0) {
                        Image("download")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 16, height: 16)
                            .foregroundStyle(.white)
                            .padding(.leading, 12)

                        Text("SAVE")
                            .font(.foundersGrotesk(.semibold, size: 14))
                            .foregroundStyle(.white)
                            .padding(.leading, 8)
                            .padding(.vertical, 8)
                            .padding(.trailing, 16)
                    }
                    .background(RoundedRectangle(cornerRadius: 16).fill(.gokuOrange600))
                }
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .overlay(alignment: .center) {
            Text("Director's Mode")
                .font(FontStyle.neueMontreal(.medium, size: 18))
                .foregroundStyle(.white)
        }
        .background(.byteBlack)
    }

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color.white.opacity(0.1)
                    .frame(width: .infinity, height: .infinity)
                
                GeometryReader { geo in
                    VStack {
                        if viewModel.isUnityByteLoaded {
                            UnityView()
                                .frame(
                                    maxWidth: viewModel.ratio == .potrait || viewModel.isRecording ? .infinity : geo.size.width,
                                    maxHeight: viewModel.ratio == .potrait || viewModel.isRecording ? .infinity : 9 / 16 * geo.size.width)
                                .padding(.bottom, viewModel.ratio == .potrait || viewModel.isRecording || viewModel.isPlaying ? 0 : viewModel.script.isEmpty ? 0 : 150)
                        } else {
                            Color.white.opacity(0.1)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .ignoresSafeArea()
                }

                if viewModel.showWatermark {
                    VStack(alignment: .leading) {
                        Text("Powered by bythen")
                            .font(.neueMontreal(.semibold, size: 16))
                            .foregroundStyle(.byteBlack)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 24)
                            .padding(.top, 32)

                        Spacer()
                    }
                }

                if !viewModel.isRecording, !viewModel.isPlaying {
                    VStack(spacing: 0) {
                        header

                        if viewModel.isUnityByteLoaded {
                            if viewModel.isHasBuild {
                                DojoOverlayView(
                                    isPlaying: $viewModel.isPlaying,
                                    enableChangeBg: $viewModel.enableChangeBg,
                                    isAssetReady: $viewModel.isAssetReady,
                                    showCaptions: $viewModel.showCaptions,
                                    script: viewModel.script,
                                    showScriptButton: viewModel.shouldShowScriptButton,
                                    onPressChangeBg: {
                                        viewModel.didSelectBottomSheet(.background)
                                    },
                                    onPressPlayButton: {
                                        AnalyticService.shared.trackClickEvent(button_name: "studio_preview_byte", value: nil)
                                        if viewModel.ratio == .landscape {
                                            BythenAppDelegate.setViewOrientation(orientation: .landscape)
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                if viewModel.isEnableStudioRecordImprovement {
                                                    viewModel.prepareUnityPlayer(recording: false)
                                                } else {
                                                    viewModel.playUnityByte()
                                                }
                                            }
                                        } else {
                                            if viewModel.isEnableStudioRecordImprovement {
                                                viewModel.prepareUnityPlayer(recording: false)
                                            } else {
                                                viewModel.playUnityByte()
                                            }
                                        }
                                        
                                    },
                                    onPressAddScript: {
                                        viewModel.shouldOpenScript.toggle()
                                    },
                                    onPressCaption: {
                                        viewModel.showCaptions.toggle()
                                    }
                                )
                            } else {
                                StudioNoBuildOverlay {
                                    let (byteID, byteSymbol) = viewModel.navToChat()
                                    navigateToChat(byteID, byteSymbol)
                                }
                            }
                        } else {
                            Spacer()
                        }

                        DojoStudioFooterView(byte: viewModel.byte) { action in
                            if case .dojo = action {
                                if viewModel.enableDojoButton {
                                    path.append(StudioNavigationPage.dojo)
                                }
                            } else {
                                viewModel.didSelectBottomSheet(action)
                            }
                        }
                    }
                    .background(Color.clear)
                    .overlay(alignment: .center) {
                        if viewModel.isChangeAvatar {
                            NetworkProgressView()
                        }
                        
                        if viewModel.isShowLoading {
                            NetworkProgressView(bgColor: .byteBlack.opacity(0.5))
                        }
                    }
                    .overlay(alignment: .bottom) {
                        if let bottomSheetType = viewModel.bottomSheetType {
                            switch bottomSheetType {
                            case .bytes:
                                ChooseByteSheetView(
                                    bytes: viewModel.bytes,
                                    initialByte: viewModel.byte,
                                    onSelectByte: viewModel.didSelectByte(_:),
                                    onCancel: viewModel.didCancelBottomSheet
                                )
                                .transition(.move(edge: .bottom))

                            case .emotion:
                                ChooseEmotionSheetView(
                                    initialEmotion: viewModel.emotion,
                                    onSelectEmotion: viewModel.didSelectEmotion(_:),
                                    onCancel: viewModel.didCancelBottomSheet
                                )
                                .transition(.move(edge: .bottom))

                            case .ratio:
                                ChooseRatioSheetView(
                                    initialRatio: viewModel.ratio,
                                    onSelectRatio: viewModel.didSelectRatio(_:),
                                    onCancel: viewModel.didCancelBottomSheet
                                )
                                .transition(.move(edge: .bottom))

                            case .speed:
                                TalkingSpeedSheetView(
                                    initialSpeed: viewModel.talkingSpeed,
                                    onChange: viewModel.didSelectTalkingSpeed(_:),
                                    onCancel: viewModel.didCancelBottomSheet
                                )
                                .transition(.move(edge: .bottom))

                            case .background:
                                ChangeBackgroundView(
                                    isPresent: Binding(
                                        get: { bottomSheetType == .background },
                                        set: { _ in viewModel.didCancelBottomSheet() }
                                    ),
                                    viewModel: viewModel.getChangeBgViewModel()
                                )
                                .colorScheme(.dark)
                                .transition(.move(edge: .bottom))

                            default:
                                EmptyView()
                            }
                        }
                    }
                    .fullScreenCover(isPresented: $viewModel.shouldOpenScript) {
                        DojoStudioBackstoryView(
                            script: viewModel.script,
                            onFinishEditing: viewModel.didFinishEditScript(_:)
                        )
                    }
                }
                
                if viewModel.captions.count > 0 {
                    VStack {
                        Spacer()
                        
                        Text(viewModel.captions)
                            .font(.foundersGrotesk(.semibold, size: viewModel.ratio == .landscape ? 28 : 32))
                            .foregroundStyle(.white)
                            .shadow(color: .byteBlack, radius: 1)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.bottom, viewModel.ratio == .landscape ? 32 : 60)
                            .padding(.horizontal, 16)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(nil)
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .background(Color.byteBlack)
            .alert(isPresented: $viewModel.showRecordingAlert) {
                Alert(
                    title: Text("Please add script to start recording"),
                    dismissButton: .default(
                        Text("Ok"),
                        action: {
                            viewModel.showRecordingAlert = false
                        }
                    )
                )
            }
            .onTapGesture {
                if viewModel.bottomSheetType != nil {
                    viewModel.didCancelBottomSheet()
                } else if viewModel.isRecording {
                    viewModel.stopRecording()
                } else if viewModel.isPlaying {
                    viewModel.stopPlaying()
                }
            }
            .onChange(of: viewModel.isVideoSaved) { newValue in
                if newValue {
                    BythenAppDelegate.setViewOrientation(orientation: .portrait)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        path.append(StudioNavigationPage.videoSaved)
                        AnalyticService.shared.trackEvent(eventName: "studio_video_saved", params: nil)
                    }
                }
            }
            .onChange(of: viewModel.isPlaying) { newValue in
                if !newValue {
                    BythenAppDelegate.setViewOrientation(orientation: .portrait)
                }
            }
            .onFirstAppear {
                viewModel.setMainState(state: mainState)
                viewModel.listenUnitySignals()
                viewModel.fetchData()
            }
            .navigationDestination(for: StudioNavigationPage.self) { selection in
                switch selection {
                case .dojo:
                    DojoView(viewModel: viewModel.getDojoViewModel())
                        .colorScheme(.dark)
                case .videoSaved:
                    if let assetID = viewModel.savedVideoID {
                        StudioSavedView(assetID: assetID, isLandscape: viewModel.ratio == .landscape)
                    }
                }
            }
            .trackView(page: "studio", className: "DojoStudioView")
        }
    }
}
