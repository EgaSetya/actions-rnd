//
//  AvatarView.swift
//  Bythen
//
//  Created by edisurata on 14/09/24.
//

import SwiftUI

enum AvatarViewRoutes: Hashable {
    case dojo(DojoTab)
}

struct AvatarView: View {
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var mainState: MainViewModel
    @StateObject var viewModel: AvatarViewModel
    @Binding var isShowRooms: Bool
    @State var isChangeBackgroundMode: Bool = false
    @State var selectedColor: Color = .blue
    @State private var path: NavigationPath = NavigationPath()
    
    var unityContainer: some View {
        VStack {
            if viewModel.avatarState != .unload {
                UnityView()
                    .ignoresSafeArea()
                    .onTapGesture {
                        if viewModel.voiceState == .interrupt {
                            viewModel.interruptResponse()
                        }
                    }
                if isChangeBackgroundMode {
                    Color.white.frame(maxWidth: .infinity, maxHeight: 300)
                }
            } else {
                Color.clear
                    .overlayProgress(isPresented: true)
            }
        }
    }
    
    var gradientHeader: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                .appBlack.opacity(0.3),
                .white.opacity(0)]),
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(maxWidth: .infinity, maxHeight: 124)
        .ignoresSafeArea()
    }
    
    var gradientFooter: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                .appBlack.opacity(0.3),
                .white.opacity(0)]),
            startPoint: .bottom,
            endPoint: .top
        )
        .frame(maxWidth: .infinity, maxHeight: 124)
        .ignoresSafeArea()
    }
    
    var topActionView: some View {
        VStack {
            HStack {
                Button {
                    withAnimation {
                        isChangeBackgroundMode = true
                    }
                } label: {
                    Image("photo-library.fill")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.byteBlack)
                        .frame(width: 20, height: 20)
                        .padding(11)
                }
                .background(.white)
                .clipShape(Circle())
                .background(
                    Circle()
                        .stroke(.appBlack, lineWidth: 1)
                )
                .padding(.trailing, 11)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.top, 8)
        }
    }

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                unityContainer
                
                VStack {
                    gradientHeader
                    Spacer()
                    gradientFooter
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.clear)
                .ignoresSafeArea()
                
                if isChangeBackgroundMode {
                    ChangeBackgroundView(
                        isPresent: $isChangeBackgroundMode,
                        viewModel: viewModel.getChangeBgViewModel()
                    )
                    .transition(.move(edge: .bottom))
                    .zIndex(1)
                } else {
                    VStack(spacing: 0) {
                        AvatarNavigationView(
                            byteName: $viewModel.byteName,
                            isTapActive: $isShowRooms,
                            navigateDojoView: DojoView(viewModel: viewModel.getDojoViewModel(selectedTab: .background)).colorScheme(.light)
                        )
                        
                        topActionView
                        
                        if viewModel.showMemoryLimit {
                            InfoTicker(
                                text: "Maximum memory reached: Delete memories to free up space. Edit Memory",
                                backgroundColor: .elmoRed100,
                                closeAction: {
                                    viewModel.showMemoryLimit = false
                                },
                                tapAction: {
                                    self.path.append(AvatarViewRoutes.dojo(.memories))
                                }
                            ).padding(16)
                        }
                        
                        Spacer()
                        
                        if viewModel.voiceState != .hidden {
                            VoiceModeView(
                                voiceState: $viewModel.voiceState,
                                isMute: $viewModel.isMute,
                                micAction: {
                                    viewModel.muteMicrophone()
                                },
                                attachmentAction: {
                                    viewModel.attachmentAction()
                                },
                                chatmodeAction: {
                                    AnalyticService.shared.trackClickEvent(button_name: "chat_mode", value: nil)
                                    viewModel.chatModeAction()
                                },
                                interruptAction: {
                                    viewModel.interruptResponse()
                                    viewModel.voiceState = .startSpeaking
                                },
                                voicePower: $viewModel.voicePower,
                                uploadProgress: $viewModel.uploadProgress,
                                uploadedFileName: $viewModel.uploadedFileName
                            )
                        }
                    }
                }
            }
            .navigationDestination(for: AvatarViewRoutes.self) { selection in
                switch selection {
                case .dojo(let tab):
                    DojoView(viewModel: viewModel.getDojoViewModel(selectedTab: tab))
                        .colorScheme(.light)
                }
            }
            .overlay(content: {
                switch viewModel.overlayViewState {
                case .onboardingDojo:
                    ZStack(alignment: .top) {
                        Color.byteBlack
                            .opacity(0.8)
                            .ignoresSafeArea()
                            .onTapGesture {
                                viewModel.overlayViewState = .empty
                            }
                        HStack(alignment: .top) {
                            Spacer()
                            HStack {
                                Image("account-balance.fill")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundStyle(.byteBlack)
                                    .frame(width: 20, height: 20)
                                    .padding(11)
                            }
                            .background(.white)
                            .clipShape(Circle())
                            .background(
                                Circle()
                                    .stroke(.appBlack, lineWidth: 1)
                            )
                            .padding(.horizontal, 12)
                        }
                        VStack(spacing: 0) {
                            HStack {
                                Spacer()
                                ArrowShape()
                                    .fill(.white)
                                    .frame(width: 12, height: 6)
                                    .rotationEffect(.degrees(180))
                                    .offset(x: 12, y: -22)
                            }
                            HStack {
                                Text("Introducing Dojo")
                                    .font(.neueMontreal(.medium, size: 16))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Button {
                                    viewModel.overlayViewState = .empty
                                } label: {
                                    Image("close")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundStyle(.byteBlack)
                                        .frame(width: 7, height: 7)
                                        .padding(7)
                                        .background(Circle().fill(.byteBlack.opacity(0.1)))
                                }
                            }
                            Text("Personalize your Byte in Dojo by customizing its personality, voice, speaking style, and more to make it uniquely yours.")
                                .font(.neueMontreal(size: 12))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 8)
                                .foregroundStyle(.byteBlack)
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                        .padding(.top, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 8).fill(.white)
                        )
                        .padding(16)
                        .padding(.top, 44)
                    }
                default:
                    EmptyView()
                }
                
            })
            .onAppear(perform: {
                Logger.logInfo("avatar on appear")
                viewModel.setMainState(state: mainState)
                viewModel.loadAvatar()
                viewModel.enableAudio = true
            })
            .onDisappear(perform: {
                Logger.logInfo("avatar on disappear")
                viewModel.stopAvatar()
                viewModel.enableAudio = false
            })
            .sheet(isPresented: $viewModel.isShowImagePicker) {
                ImagePicker(
                    didFinishPicking: { image in
                        viewModel.didSelectImage(image: image)
                    },
                    didFailedValidation: {
                        mainState.showError(errMsg: "The file exceeds the 20MB size limit. Please select a smaller file.")
                    },
                    didCancel: {
                        viewModel.muteMicrophone()
                    }
                )
                .ignoresSafeArea(.all)
            }
            .onChange(of: scenePhase) { newPhase in
                // Trigger something when the app comes to the foreground
                if newPhase == .background {
                    viewModel.enableAudio = false
                    viewModel.interruptResponse()
                } else {
                    viewModel.enableAudio = true
                    viewModel.avatarState = .ready
                }
            }
        }
    }
}

#Preview {
    
    AvatarView(viewModel: AvatarViewModel.new(byteBuild: ByteBuild(), onboarding: true), isShowRooms: .constant(false))
        .environmentObject(MainViewModel.new())
}
