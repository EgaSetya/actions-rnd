//
//  MyCollectionsView.swift
//  Bythen
//
//  Created by edisurata on 01/09/24.
//

import SwiftUI

struct MyCollectionView: View {
    @EnvironmentObject var mainState: MainViewModel
    @EnvironmentObject var sideMenuContent: SideMenuContentViewModel
    private let kTabMenuTitles = ["BYTE", "INFO", "SUMMARY"]
    
    var goToChatRoomAction: (_ byteID: Int64, _ byteSymbol: String) -> Void
    
    @State var pageIndicatorOffset = 0.0
    @State var pageIndicatorIdx = 0
    @State var selectedTab = 0
    @FocusState var isFocused: Bool
    
    @StateObject private var viewModel = MyCollectionViewModel.new()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                Spacer()
                if viewModel.isByteActive && selectedTab == 0 {
                    UnityView()
                }
                
                if viewModel.isLoadingBytes && selectedTab == 0 {
                    Color.clear.overlayProgress(isPresented: viewModel.isLoadingBytes)
                }
                
            }.frame(maxHeight: .infinity)
                .zIndex(0)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    SideMenuButton()
                    Spacer()
                }
                .padding(.horizontal, 16)
                
                MyCollectionTabView(
                    selectedTab: $selectedTab,
                    titles: kTabMenuTitles,
                    content: {
                        ZStack {
                            Color.clear
                                .contentShape(Rectangle())
                                .gesture(DragGesture())
                            ByteView(
                                isOriginalNftValid: $viewModel.isOriginalNFTValid,
                                isBythenPodValid: $viewModel.isBythePodValid,
                                isPrimary: $viewModel.isPrimary,
                                isTrial: $viewModel.isTrial,
                                byteName: $viewModel.byteName,
                                showAssetNotReadyBanner: $viewModel.isByteAssetNotReady,
                                showTrialCountdown: $sideMenuContent.showTrialCountdown,
                                countdown: $sideMenuContent.trialCountdown,
                                showOriginalNftInvalidBanner: $viewModel.showInvalidOriginalNFTBanner
                            )
                        }
                        .tag(0)
                        
                        ZStack {
                            Color.clear
                                .contentShape(Rectangle())
                                .gesture(DragGesture())
                            ByteInfoView(
                                initialDesc: viewModel.byteInfoDesc,
                                desc: $viewModel.byteInfoDesc
                            )
                        }
                        .tag(1)
                        
                        ZStack {
                            Color.clear
                                .contentShape(Rectangle())
                                .gesture(DragGesture())
                            ByteSummaryView(viewModel: viewModel.summaryVM)
                        }
                        .tag(2)
                    },
                    isEnableFirstTab: $viewModel.isByteAssetNotReady)
            }
            .transaction { transaction in
                transaction.animation = nil
            }
            
            VStack {
                BasicSquareButton(
                    title: "CHAT NOW",
                    background: ByteColors.foreground(for: theme()),
                    foregroundColor: ByteColors.background(for: theme()),
                    rightIconName: viewModel.isDarkMode ? AppImages.kBytesChatArrowDark : AppImages.kBytesChatArrow
                ) {
                    let (byteID, ByteSymbol) = viewModel.navigateToChatroom()
                    goToChatRoomAction(byteID, ByteSymbol)
                }
                .frame(height: 48).padding()
                .padding(.top, -20)
                
                if viewModel.byteList.count > 0 && !isFocused {
                    
                    ByteSelectionView(
                        byteList: $viewModel.byteList,
                        selectedIdx: $viewModel.selectedByteIdx
                    )
                    .frame(maxHeight: 100)
                    
                    Text("\(viewModel.podCount) PODS, \(viewModel.avatarCount) AVATARS")
                        .font(FontStyle.foundersGrotesk(.semibold, size: 12))
                        .foregroundColor(ByteColors.foreground(for: theme()))
                }
            }.padding(.bottom, 0)
        }
        .background(Color(hex: viewModel.backgroundColorHex))
        .onAppear(perform: {
            viewModel.setMainState(state: mainState)
            viewModel.fetchByteList()
        })
        .trackView(page: "my_collection", className: "MyCollectionView")
        .onDisappear(perform: {
        })
        .overlay(content: {
            if viewModel.isShowLoading {
                ByteLoadingView().background(.byteBlack)
            } else {
                EmptyView()
            }
        })
        .colorScheme(theme())
    }
    
    func theme() -> ColorScheme {
        return viewModel.isDarkMode ? .dark : .light
    }
}

#Preview {
    MyCollectionView(goToChatRoomAction: { id, symbol in
        
    })
        .environmentObject(MainViewModel.new())
        .environmentObject(SideMenuContentViewModel.new())
}
