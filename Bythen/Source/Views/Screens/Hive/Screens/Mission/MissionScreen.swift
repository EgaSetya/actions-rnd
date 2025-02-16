//
//  MissionScreen.swift
//  Bythen
//
//  Created by Darul Firmansyah on 31/12/24.
//

import SwiftUI

enum MissionScreenViewState {
    case pageLoading
    case loaded
}

enum MissionSectionName {
    case completed
    case available
}

enum MissionSectionState {
    case idle
    case initialLoading
    case empty
    case paginationLoading
}

struct MissionScreen: View {
    @EnvironmentObject
    var sideMenuState: SideMenuContentViewModel
    @EnvironmentObject
    var mainState: MainViewModel
    
    @StateObject
    private var viewModel = MissionScreenViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack {
                switch viewModel.screenViewState {
                case .pageLoading:
                    MissionScreenShimmerView()
                        .task {
                            viewModel.setMainState(state: mainState)
                            await viewModel.onAppear()
                        }
                case .loaded:
                    contentView
                }
            }
        }
        .embedHiveNavigationBar()
        .padding(.bottom, 12)
        .frame(maxWidth: .infinity)
        .ignoresSafeArea()
        .background(.byteBlack)
        .sheet(isPresented: $viewModel.showWebView) {
            if let url = viewModel.twitterAuthURL {
                MissionWebViewContainer(showWebView: $viewModel.showWebView, url: url, delegate: self)
            }
            else if let postURL = viewModel.goToPostURL {
                MissionWebViewContainer(showWebView: $viewModel.showWebView, url: postURL, delegate: self)
            }
        }
        .overlay {
            if viewModel.isTwitterPopupPresented {
                VisualEffectView(effect: UIBlurEffect(style: .systemThickMaterialDark))
                    .edgesIgnoringSafeArea(.all)
                
                MissionConnectAccountView(
                    onConnectTapped: {
                        viewModel.onTwitterConnect()
                    },
                    onGoBackTapped: {
                        sideMenuState.selectedPage = .hive
                    }
                )
                .padding(.horizontal, 16)
            }
        }
    }
    
    var contentView: some View {
        Group {
            headerView
            
            Color.clear
                .frame(height: 20)
            
            createMissionList(sectionName: .available, sectionState: viewModel.availableMissionState, missions: viewModel.availableMissions)
            completedMissionsSection
        }
    }
    
    var headerView: some View {
        VStack(spacing: 10) {
            HStack(alignment: .center) {
                HStack(spacing: 4) {
                    Text("Total Nectar".uppercased())
                        .font(FontStyle.dmMono(.medium, size: 11))
                        .foregroundStyle(.white)
                    
                    Button {
                        viewModel.onNectarInfoTapped()
                    } label: {
                        Image("info")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundStyle(.white)
                    }
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image("nectar-icon")
                        .resizable()
                        .foregroundStyle(.white)
                        .frame(width: 20, height: 20)
                    
                    Text(viewModel.totalNectar ?? "")
                        .font(FontStyle.neueMontreal(.medium, size: 16))
                        .foregroundStyle(.white)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 18)
            .background(Color.gokuOrange600)
            .frame(maxWidth: .infinity)
            .clipShape(Capsule(style: .circular))
            .overlay(alignment: .top, content: {
                banner
            })
            
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("BYTESHIVE")
                        .font(FontStyle.foundersGrotesk(.semibold, size: 18))
                        .foregroundStyle(Color(hex: "#E9D447"))
                    if let image = UIImage(named: "mission_text_logo") {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 31)
                    }
                }
                Text("Take on exciting missions and unlock exclusive rewards! Stay tuned for more missions and updates")
                    .font(FontStyle.neueMontreal(.regular, size: 14))
                    .foregroundStyle(Color.white)
            }
            .padding(.top, 24.0)
        }
        .padding(.vertical, 36)
        .padding(.horizontal, 16)
        .overlay(alignment: .bottomLeading) {
            VStack(alignment: .center) {
                HStack(alignment: .center) {
                    Rectangle()
                        .fill(Color.sonicBlue500)
                        .frame(width: 8, height: 8)
                    Text("AVAILABLE MISSION (\(viewModel.availableMissions.count))")
                        .font(FontStyle.dmMono(.medium, size: 12))
                        .foregroundStyle(Color.white)
                }
                .padding(.horizontal, 20)
            }
            .frame(height: 36)
            .background(Color.byteBlack)
            .border(Color.ghostWhite300, width: 1)
            .offset(x: 16, y: 18)
        }
        .overlay(alignment: .topLeading) {
            getNectarTooltip()
        }
        .background {
            Image("mission-cover")
                .resizable()
                .frame(maxWidth: .infinity)
                .overlay {
                    Color.black.opacity(0.8)
                }
        }
    }
    
    var banner: some View {
        let screenHeight = UIScreen.main.bounds.height
        let presentPosition = -screenHeight / 2.5
        
        return Banner.dialog(
            type: viewModel.bannerState.type,
            text: viewModel.bannerState.text,
            showCloseButton: viewModel.bannerState.showCloseButton,
            isPresented: $viewModel.bannerState.shouldShow
        )
        .padding(.horizontal, 20)
        .padding(.top, abs(presentPosition))
    }
    
    @ViewBuilder
    var completedMissionsSection: some View {
        if !viewModel.completedMissions.isEmpty {
            Group {
                VStack {
                    Rectangle()
                        .fill(Color.ghostWhite300)
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                        .overlay(alignment: .leading) {
                            VStack(alignment: .center) {
                                HStack(alignment: .center) {
                                    Rectangle()
                                        .fill(Color.yoshiGreen600)
                                        .frame(width: 8, height: 8)
                                    Text("COMPLETED MISSION (\(viewModel.completedMissionCount))")
                                        .font(FontStyle.dmMono(.medium, size: 12))
                                        .foregroundStyle(Color.white)
                                }
                                .padding(.horizontal, 20)
                            }
                            .frame(height: 36)
                            .background(Color.byteBlack)
                            .border(Color.ghostWhite300, width: 1)
                            .padding(.leading, 16.0)
                        }
                }
                .padding(.top, 18)
                .padding(.bottom, 38)
                
                createMissionList(sectionName: .completed, sectionState: viewModel.completedMissionState, missions: viewModel.completedMissions)
            }
        }
    }
    
    @ViewBuilder
    func createMissionList(sectionName: MissionSectionName, sectionState: MissionSectionState, missions: [MissionDetailViewModel]) -> some View {
        switch sectionState {
        case .empty:
            MissionEmptyView()
        case .initialLoading:
            MissionListShimmerView()
        default:
            ForEach(missions, id: \.self) { mission in
                MissionDetailView(missionDetailVM: mission) {
                    viewModel.goToPost(for: mission)
                } verify: {
                    Task {
                        await viewModel.verifyMission(for: mission)
                    }
                }
            }
            
            Color.clear
                .frame(height: 1)
                .onAppear {
                    Task {
                        await viewModel.loadMoreContent()
                    }
                }
            
            if sectionState == .paginationLoading {
                VStack(alignment: .center) {
                    ProgressView()
                        .frame(width: 44, height: 44)
                }
            }
        }
    }
    
    @ViewBuilder
    func getNectarTooltip() -> some View {
        if viewModel.isShowNectarTooltip {
            Tooltip(
                content: "Nectar is a reward for your loyalty and participation in bythen ecosystem. Earn more Nectar through missions, earning honey and more. We have a special surprise for all Nectar owners to stay tuned.",
                style: .smallArrowedTop,
                textStyle: .regular,
                backgroundStyle: .dark
            )
            .frame(width: 250, height: 120, alignment: .leading)
            .zIndex(0)
            .offset(x: 0, y: 55)
            .onTapGesture {
                viewModel.isShowNectarTooltip = false
            }
        }
    }
}

extension MissionScreen: MissionWebViewDelegate {
    func onAuthorized(oauthToken: String, oauthVerifier: String) {
        viewModel.showWebView = false
        viewModel.connectTwitter(oauthToken: oauthToken, oauthVerifier: oauthVerifier)
    }
    
    func onCancel() {
        viewModel.showWebView = false
        viewModel.showTwitterConnectPopupIfNeeded()
    }
    
    func onRejected() {
        viewModel.showWebView = false
        viewModel.showTwitterConnectPopupIfNeeded()
    }
}
