//
//  ChatroomView.swift
//  Bythen
//
//  Created by edisurata on 14/09/24.
//

import SwiftUI

struct ChatroomView: View {
    @EnvironmentObject
    var mainState: MainViewModel

    @StateObject
    var viewModel: ChatroomViewModel

    var body: some View {
        GeometryReader { _ in
            ZStack {
                switch viewModel.page {
                case .avatar:
                    AvatarView(
                        viewModel: viewModel.getAvatarViewModel(),
                        isShowRooms: $viewModel.isShowRooms)
                case .onboarding:
                    OnboardingChatView(viewModel: viewModel.getOnboardingChatVM())
                case .chat:
                    ChatView(viewModel: viewModel.getChatViewModel(), isShowRooms: $viewModel.isShowRooms)
                        .task {
                            await viewModel.bindChatVM()
                        }
                        .transition(.move(edge: .trailing))
                case .changeAvatar:
                    VStack {
                        HStack {
                            SideMenuButton().padding(12)
                            Spacer()
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.appBlack)
                }
                
                if viewModel.isShowLoading {
                    ByteLoadView(
                        isCompleted: $viewModel.isByteLoaded,
                        byteName: $viewModel.byteName
                    ) {
                        withAnimation(.easeInOut(duration: 1)) {
                            viewModel.changeAvatarLoadingComplete()
                        }
                    }
                    .transition(.move(edge: .top))
                    .zIndex(1)
                }
                

                if viewModel.isShowRooms {
                    RoomsView(viewModel: viewModel.getRoomsVM(), isPresent: $viewModel.isShowRooms)
                        .transition(.move(edge: .bottom))
                        .ignoresSafeArea(edges: .bottom)
                        .zIndex(1)
                }
            }
            .trackView(page: "chat_room", className: "ChatroomView")
            .background(.appCream)
            .onAppear {
                viewModel.setMainState(state: mainState)
                viewModel.fetchData()
            }
            .onDisappear {
                viewModel.page = .changeAvatar
            }
            .alert(isPresented: $viewModel.isNotInternetConnection) {
                Alert(
                    title: Text("No Internet Connection"),
                    message: Text("Please check your network settings to ensure you're connected."),
                    dismissButton: .default(Text("Retry"), action: {
                        viewModel.isNotInternetConnection = false
                        viewModel.fetchData()
                    })
                )
            }
        }
    }
}
