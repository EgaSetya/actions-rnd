//
//  HiveDashboardView.swift
//  Bythen
//
//  Created by erlina ng on 17/11/24.
//

import SwiftUI
import AVKit

struct HiveDashboardView: View {
    @Environment(\.openURL) var openURL
    @StateObject var viewModel: HiveDashboardViewModel = HiveDashboardViewModel.new()
    @EnvironmentObject
    var sideMenuState: SideMenuContentViewModel
    
    @State var isShowSharePopUp: Bool = false
    @State var isShowBottomSheet: Bool = false
    @State var shouldShowWelcomeView: Bool = false
    @State var shouldShowHiveTree: Bool = false
    
    let topLink: String = "hive-button-animation-top"
    let bottomLink: String = "hive-button-animation-bottom"
    
    var body: some View {
        ZStack {
            ScrollViewReader { value in
                ScrollView {
                    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                        Section {
                            header
                                .padding(.horizontal, 20)
                                .id("header")
                            
                            summary
                            
                            commission
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(StringRepository.hiveReferralHeaderCopy.getString())
                                    .font(Font.neueMontreal(.medium, size: 14))
                                    .foregroundStyle(Color.byteBlack)
                                
                                Text(StringRepository.hiveReferralSubheaderCopy.getString())
                                    .font(Font.neueMontreal(size: 12))
                                    .foregroundStyle(Color.byteBlack)
                                
                                HStack(spacing: 0) {
                                    Text(viewModel.referalCode)
                                        .font(Font.dmMono(.medium, size: 18))
                                        .foregroundStyle(Color.black)
                                        .lineSpacing(6)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .padding(.vertical, 12)
                                    
                                    Button {
                                        UIPasteboard.general.string = viewModel.referalCode
                                        viewModel.showToaster()
                                    } label: {
                                        HStack {
                                            Image("hive-copy")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 24, height: 24)
                                        }
                                        .padding(12)
                                        .background(Color.white)
                                    }
                                }
                                .background(Color(hex: "#C4B237"))
                                .padding(.top, 8)
                                
                                Button {
                                    isShowSharePopUp = true
                                } label: {
                                    VStack(spacing: 0) {
                                        ByteGifView(topLink)
                                            .frame(height: 15)
                                        HStack {
                                            Text("SHARE LINK")
                                                .font(Font.foundersGrotesk(.semibold, size: 18))
                                                .foregroundStyle(Color.byteBlack)
                                                .padding(.vertical, 16)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .background(Color.white)
                                        ByteGifView(bottomLink)
                                            .frame(height: 15)
                                    }
                                }
                                .padding(.top, 8)
                                
                                Text(StringRepository.hiveReferralFooterCopy.getString())
                                    .font(Font.neueMontreal(.regular, size: 12))
                                    .foregroundStyle(.byteBlack)
                                    .underline()
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 8)
                                    .padding(.bottom, 24)
                                    .onTapGesture {
                                        if let url = URL(string: "https://bythen-ai.gitbook.io/byteshive-guide") {
                                            openURL(url)
                                        }
                                    }
                            }
                            .padding(.horizontal, 36)
                            .padding(.top, 24)
                            .padding(.bottom, 30)
                            .background(Color.byteYellow)
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .background(.byteBlack)
            .overlay {
                if viewModel.showRankDetailBottomsheet {
                    HiveDashboardBottomSheet(viewModel: viewModel.getHiveBottomsheetVM())
                        .transition(.move(edge: .bottom))
                }
                
                HiveWelcomeView(
                    viewModel: $viewModel.hiveOnboardingAssetViewModel,
                    isShowing: $shouldShowWelcomeView
                )
                
                if shouldShowHiveTree {
                    CustomWebView(
                        url: URL(string: "\(AppConfig.webBaseURL)/byteshive?showhive=true"),
                        cookies: [
                            "access_token":  AppSession.shared.getAuthToken() ?? "",
                            "wallet_address": AppSession.shared.getCurrentAccount()?.walletAddress ?? ""
                        ],
                        title: "HIVE DETAILS"
                    ) {
                        withAnimation {
                            shouldShowHiveTree.toggle()
                        }
                    }
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
            .onAppear {
                viewModel.putHive()
            }
            .onChange(of: viewModel.shouldShowWelcomeView) { newValue in
                shouldShowWelcomeView = newValue
            }
            
            if viewModel.isShowToaster {
                VStack {
                    Banner.customView(HiveToasterView())
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        }
        .embedHiveNavigationBar()
        .sheet(isPresented: $isShowSharePopUp) {
            ShareSheet(items: [viewModel.shareReferralText])
        }
    }
    
    // MARK: - Header View
    var header: some View {
        VStack {
            HStack {
                ZStack {
                    if viewModel.profileImageURL.isNotEmpty {
                        CachedAsyncImage(urlString: viewModel.profileImageURL)
                            .scaledToFill()
                            .clipShape(HexagonShape())
                    } else {
                        Color.appBlack
                            .clipShape(HexagonShape())
                        
                        Image("hive-empty-profile")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    }
                    
                    if let commision = viewModel.commision {
                        AsyncImage(url: URL(string: commision.frameURL)) { phase in
                            if case let .success(image) = phase {
                                image
                                    .resizable()
                                    .scaledToFit()
                            } else {
                                Image("hive-inactive-badge")
                                    .resizable()
                                    .scaledToFit()
                            }
                        }
                        .if(commision.showStar) {
                            $0.overlay(alignment: .topLeading) {
                                Image(AppImages.kTopStarIcon)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 28, height: 28)
                                    .offset(x: -6, y: -6)
                            }
                        }
                        .if(commision.showStar) {
                            $0.overlay(alignment: .bottom) {
                                Image(AppImages.kTopStarIcon)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 14, height: 14)
                                    .offset(y: 6)
                            }
                        }
                        .if(commision.showStar) {
                            $0.overlay(alignment: .bottomTrailing) {
                                Image(AppImages.kTopStarIcon)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 20, height: 20)
                                    .offset(x: 8)
                            }
                        }
                    }
                }
                .frame(width: 61, height: 68)
                Spacer()
            }
            .padding(.top, 24)
            
            HStack(alignment: .bottom, spacing: 0) {
                Text("\($viewModel.username.wrappedValue)'S HIVE ")
                    .font(Font.foundersGrotesk(.semibold, size: 40))
                    .foregroundStyle(Color.white)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .scaledToFit()
                    .padding(.trailing, 10)
                accountTypeChip
                    .padding(.bottom, 8)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("YOUR RANK")
                    .font(Font.dmMono(.medium, size: 11))
                    .foregroundStyle(Color.white.opacity(0.5))
                
                rankButton
                    .padding(.bottom, 4)
                
                if viewModel.isShowCommissionView {
                    commisionButton
                }
                
                if viewModel.isShowCountDown {
                    HiveCountdownView(seconds: viewModel.trialCountDown)
                        .padding(.top, 4)
                }
            }
        }
        .padding(.bottom, 24)
        .background(.byteBlack)
    }
    
    var accountTypeChip: some View {
        HStack {
            Text(viewModel.accountTypeText.uppercased())
                .font(Font.dmMono(.medium, size: 11))
                .foregroundStyle(viewModel.accountTypeForegroundColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 20).fill(viewModel.accountTypeChipColor)
                )
        }
    }
    
    var rankButton: some View {
        Button {
            viewModel.showRankDetailBottomsheet.toggle()
        } label: {
            HStack {
                Image(viewModel.rankIcon)
                    .padding(.leading, 12)
                
                Spacer()
                
                Text(viewModel.tierNameText)
                    .font(Font.dmMono(.medium, size: 11))
                    .foregroundStyle(viewModel.isRoyalBee ? Color(hex: "#63591C") : Color.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(viewModel.isRoyalBee ? Color(hex: "#63591C") : Color.white)
                    .frame(height: 7)
                    .padding(.trailing, 12)
            }
            .frame(height: 40)
            .background( LinearGradient(
                colors: viewModel.rankBackgroundColors,
                startPoint: .leading,
                endPoint: .trailing
            ))
        }
        
    }
    
    var commisionButton: some View {
        HStack(alignment: .center, spacing: 4) {
            Text(viewModel.commissionTitle)
                .multilineTextAlignment(.leading)
                .font(Font.neueMontreal(.regular, size: 12))
                .foregroundStyle(viewModel.isActive ? Color.black : Color.white )
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background( viewModel.isActive ? Color.byteYellow : Color.elmoRed500 )
    }
    
    // MARK: - Summary View
    
    var summary: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("HIVE'S SUMMARY")
                    .font(Font.foundersGrotesk(.semibold, size: 16))
                    .foregroundStyle(Color.white.opacity(0.8))
                    .padding(.top, 16)
                    .padding(.bottom, 12)
                
                Spacer()
                
                Button {
                    withAnimation {
                        shouldShowHiveTree.toggle()
                    }
                } label: {
                    HStack(alignment: .center, spacing: 8) {
                        Image(.hiveIcon)
                            .renderingMode(.template)
                            .resizable()
                            .frame(square: 10)
                        
                        Text("HIVE DETAILS")
                            .font(.dmMono(.medium, size: 11))
                    }.foregroundStyle(HiveColors.pacmanYellow300)
                }
            }
            
            HiveSummaryBlockView(
                title: "Nectar",
                tooltipMessage: "You’ll earn Nectar every time you generate Honey or complete missions from Bythen. Nectar is a future reward that recognizes your loyalty and active participation in the Bytes Hive ecosystem.",
                tooltipSide: .left,
                amount: $viewModel.totalNectars,
                amountInDollar: .constant("")
            )
            
            HStack(spacing: 4) {
                HiveSummaryBlockView(
                    title: "Honey",
                    tooltipMessage: "70% of the Honey you’ve earned in Bytes Hive, can be withdrawn to your connected wallet.",
                    tooltipSide: .top,
                    amount: $viewModel.honeyAmount,
                    amountInDollar: $viewModel.honeyAmountValue
                )
                
                HiveSummaryBlockView(
                    title: "Locked Honey",
                    tooltipMessage: "30% of the Honey you’ve earned in Bytes Hive can be redeemed at the Bythen Store but cannot be withdrawn.",
                    tooltipSide: .left,
                    amount: $viewModel.lockedHoneyAmount,
                    amountInDollar: $viewModel.lockedHoneyAmountValue
                )
            }
        }
        .padding(.bottom, 12)
        .padding(.horizontal, 20)
        .background(Color.white.opacity(0.05))
    }
    
    // MARK: - Commission View
    var commission: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("HIVE'S COMMISSION")
                    .font(Font.foundersGrotesk(.semibold, size: 16))
                    .foregroundStyle(Color.white.opacity(0.8))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 12)
            
            if viewModel.hiveCommision?.hivePoints.isEmpty ?? true {
                VStack {
                    Image("hive-commission-empty")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color.white.opacity(0.4))
                        .frame(height: 24)
                    
                    Text("No activity has been recorded.")
                        .lineLimit(nil)
                        .multilineTextAlignment(.center)
                        .font(Font.neueMontreal(.regular, size: 12))
                        .foregroundStyle(Color.white.opacity(0.4))
                        .padding(.top, 12)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 12)
                .padding(.vertical, 46)
                .background(Color.byteBlack)
            } else {
                commissionLists
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
        .background(Color.white.opacity(0.05))
    }
    
    var commissionLists : some View {
        VStack(spacing: 1) {
            ForEach(viewModel.hiveCommision?.hivePoints ?? [], id: \.id) { data in
                HStack {
                    Text("\(data.createdAt.convertToDateFormat())")
                        .font(Font.neueMontreal(.regular, size: 12))
                        .foregroundStyle(Color.white.opacity(0.4))
                        .frame(width: 70)
                        .padding(8)
                    
                    HStack(spacing: 0) {
                        Text("\(data.rewardTypeTitle)")
                            .font(Font.neueMontreal(.regular, size: 12))
                            .foregroundStyle(Color.white.opacity(0.8))
                        
                        Spacer()
                        
                        Text("\(data.totalPoint)")
                            .foregroundStyle(Color.white.opacity(0.8))
                            .font(Font.dmMono(.bold, size: 12))
                        
                        Text("($\(data.totalPointUSD))")
                            .foregroundStyle(Color.white.opacity(0.5))
                            .font(Font.dmMono(.bold, size: 12))
                            .truncationMode(.tail)
                            .frame(maxWidth: 70, maxHeight: 15, alignment: .trailing)
                    }
                    .padding(8)
                    
                }
                .background(Color.byteBlack)
            }
        }
    }
}
