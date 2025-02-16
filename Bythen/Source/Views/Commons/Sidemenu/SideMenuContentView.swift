//
//  SideMenuContentView.swift
//  Bythen
//
//  Created by edisurata on 25/09/24.
//

import SwiftUI

struct SideMenuContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var mainState: MainViewModel
    @EnvironmentObject var pushNotificationManager: PushNotificationManager

    @StateObject
    var viewModel: SideMenuContentViewModel

    var body: some View {
        ZStack {
            renderMainPages()
            
            if viewModel.isShowSideMenu {
                SideMenuView(
                    theme: .constant(viewModel.isDarkMode ? .dark : .light),
                    isPresented: $viewModel.isShowSideMenu,
                    selectedPage: $viewModel.selectedPage,
                    notificationIconConfiguration: $viewModel.notificationIconConfiguration,
                    configuration: $viewModel.menuConfig,
                    infoViewModel: viewModel.infoViewModel,
                    selectMenuAction: { page in
                        viewModel.navigateToPage(page)
                    },
                    logoutAction: {
                        viewModel.logout()
                    },
                    notificationListAction: {
                        viewModel.isShowNotificationList = true
                    }
                )
                .transition(.move(edge: .leading)) // Slide in from left
                .animation(.easeInOut(duration: 0.5), value: viewModel.isShowSideMenu)
                .zIndex(1)
            }
        }
        .onAppear {
            viewModel.setMainState(state: mainState)
            viewModel.fetchUserData()
            viewModel.fetchNotificationStatus()
        }
        .onChange(of: scenePhase) { newPhase in
            // Trigger something when the app comes to the foreground
            if newPhase == .active {
                viewModel.fetchUserData(isFromBackground: true)
            }
        }
        .onReceive(pushNotificationManager.$action) { action in
            handlePushNotification(action)
        }
        .fullScreenCover(isPresented: $viewModel.isShowNotificationList) {
            NotificationListScreen()
        }
    }
    
    private func renderMainPages() -> some View {
        Group {
            switch viewModel.selectedPage {
            case .mycollection:
                MyCollectionView { byteID, byteSymbol in
                    withAnimation {
                        viewModel.navigateToChatRoom(byteID: byteID, byteSymbol: byteSymbol)
                    }
                }
                .environmentObject(viewModel)
            case .chat:
                ChatroomView(viewModel: viewModel.getChatroomViewModel())
                    .environmentObject(viewModel)
            case .studio:
                DojoStudioView(navigateToChat: { byteID, byteSymbol in
                    viewModel.navigateToChatRoom(byteID: byteID, byteSymbol: byteSymbol)
                })
                .environmentObject(viewModel)
            case .termsOfUse:
                TermsOfServiceView(
                    didAccept: { isTOSAccepted, canBeContacted in
                        viewModel.acceptTermsOfService(isTOSAccepted, canBeContacted: canBeContacted)
                    }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .zIndex(1)
            case .freeTrialEnded:
                FreetrialEndedView(
                    tokenSymbol: $viewModel.trialTokenSymbol,
                    closeButtonAction: {
                        viewModel.selectedPage = .mycollection
                    }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .zIndex(1)
            case .accountSetup:
                AccountSetupView(
                    didTapClose: { viewModel.finishAccountSetup() }
                )
            case .profile:
                ProfileScreen(viewModel: ProfileScreenViewModel(authService: AuthService(), mediaService: DefaultMediaService()))
                    .environmentObject(viewModel)
            case .hive:
                HiveDashboardView()
                    .environmentObject(viewModel)
            case .mission:
                MissionScreen()
                    .environmentObject(viewModel)
            case .hiveEarnings:
                HiveEarningsScreen(viewModel: HiveEarningsViewModel())
                    .environmentObject(viewModel)
            case .hiveLeaderboard:
                HiveLeaderboardScreen()
                    .environmentObject(viewModel)
            default:
                VStack {
                    NetworkProgressView()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.byteBlack)
            }
        }
    }
    
    private func handlePushNotification(_ action: PushNotificationAction?) {
        if action == .openHive {
            viewModel.selectedPage = .hive
        }
        else if action == .openNotifications {
            viewModel.isShowNotificationList = true
        }
    }
}

#Preview {
    SideMenuContentView(viewModel: SideMenuContentViewModel.new())
        .environmentObject(MainViewModel.new())
}
