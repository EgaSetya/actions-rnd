//
//  HiveLeaderboardScreen.swift
//  Bythen
//
//  Created by Ega Setya on 05/02/25.
//

import SwiftUI

import MarkdownUI

struct HiveLeaderboardRankViewModel {
    let rank: Int
    let username: String
    let referrals: Int
}

enum HiveLeaderboardTab {
    case rank
    case rules
}

struct HiveLeaderboardScreen: View {
    @EnvironmentObject var mainState: MainViewModel
    @Environment(\.openURL) var openURL
    
    @State private var selectedTab: HiveLeaderboardTab = .rank
    
    var rankMocks: [HiveLeaderboardRankViewModel] {
        [
            HiveLeaderboardRankViewModel(rank: 1, username: "sharkie_daddy", referrals: 1523),
            HiveLeaderboardRankViewModel(rank: 2, username: "sharkie_daddy", referrals: 1523),
            HiveLeaderboardRankViewModel(rank: 3, username: "sharkie_daddy", referrals: 1523),
            HiveLeaderboardRankViewModel(rank: 4, username: "sharkie_daddy", referrals: 1523),
            HiveLeaderboardRankViewModel(rank: 5, username: "sharkie_daddy", referrals: 1523),
            HiveLeaderboardRankViewModel(rank: 6, username: "sharkie_daddy", referrals: 1523),
            HiveLeaderboardRankViewModel(rank: 7, username: "sharkie_daddy", referrals: 1523),
            HiveLeaderboardRankViewModel(rank: 8, username: "sharkie_daddy", referrals: 1523),
            HiveLeaderboardRankViewModel(rank: 9, username: "sharkie_daddy", referrals: 1523),
            HiveLeaderboardRankViewModel(rank: 10, username: "sharkie_daddy", referrals: 1523)
        ]
    }
    
    @ViewBuilder
    var headerView: some View {
        LazyVStack(alignment: .leading, spacing: 0) {
            Group {
                Text("THE")
                    .font(.foundersGrotesk(.semibold, size: 16))
                    .foregroundStyle(HiveColors.mainYellow)
                
                Text("HIVE RACE")
                    .font(.foundersGrotesk(.semibold, size: 40))
                    .padding(.bottom, 8)
                    .foregroundStyle(HiveColors.mainYellow)
                
                Text("Season 1 ENDS IN 28 FEB 2025 11:59 PM UTC")
                    .font(.foundersGrotesk(.semibold, size: 12))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .foregroundStyle(.white)
                    .background(
                        Rectangle().fill(.ghostWhite400).border(.ghostWhite800, width: 1)
                    )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Group {
                Text("Total Prize Pool")
                    .font(.drukWide())
                    .padding(.top, 78)
                
                Text("4500.80 eth")
                    .font(.drukWide(size: 36))
                    .padding(.top, 12)
                
                Text("($155.401,20 USD)")
                    .font(.dmMono(size: 14))
                    .padding(.top, 8)
                
                Text("Take part in our exciting monthly referral contest at Byte Hive! Every referral counts as you compete to be among the top 30 members who will share in the substantial prize pool. Every Bythen product sold adds to the pot, increasing your potential winnings as our community grows.")
                    .font(.neueMontreal())
                    .multilineTextAlignment(.center)
                    .padding(.top, 72)
                    .padding(.bottom, 40)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 4)
        .padding(.horizontal, 16)
        .background(.totoroGrey1000)
    }
    
    @ViewBuilder
    var tabButton: some View {
        HStack(spacing: 0) {
            Group {
                Button {
                    selectedTab = .rank
                } label: {
                    Text("LEADERBOARD")
                        .font(.foundersGrotesk(.semibold, size: 14))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 30)
                }
                .conditionalModifier(selectedTab == .rank) { view in
                    view.background(.ghostWhite200)
                }
                
                Button {
                    selectedTab = .rules
                } label: {
                    Text("HOW IT WORKS")
                        .font(.foundersGrotesk(.semibold, size: 14))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 30)
                }
                .conditionalModifier(selectedTab == .rules) { view in
                    view.background(.ghostWhite200)
                }
            }
            .padding(4)
        }
        .frame(alignment: .center)
        .foregroundStyle(.white)
        .background(
            Rectangle().fill(.ghostWhite100).border(.ghostWhite300, width: 1)
        )
        .padding(.top, 40)
        .padding(.horizontal, 44)
    }
    
    @ViewBuilder
    var rankListHeaderView: some View {
        HStack(spacing: 0) {
            Group {
                Text("RANK")
                    .frame(width: 56, alignment: .center)
                
                Text("USER")
                    .padding(.leading, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("REFERRALS")
                    .frame(width: 97, alignment: .center)
            }
            .font(.dmMono(.semibold))
            .foregroundStyle(.white)
            .padding(.vertical, 16)
        }
        .background(
            Rectangle().border(.ghostWhite300, width: 1)
        )
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    var rankListView: some View {
        Group {
            HStack {
                Group {
                    createChevronButton()
                    
                    Text("SEPTEMBER")
                        .font(.dmMono(.semibold, size: 16))
                        .minimumScaleFactor(0.85)
                        .foregroundStyle(.white)
                    
                    createChevronButton(true)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 10)
            }
            .frame(height: 48, alignment: .center)
            .background(
                Rectangle().border(.ghostWhite200, width: 1)
            )
            .padding(.top, 48)
            .padding(.bottom, 40)
            .padding(.horizontal, 85)
            
            HStack {
                Text("Top Earners")
                    .font(.neueMontreal(.bold, size: 14))
                    .foregroundStyle(.white)
                
                Spacer()
                
                Text("Last updated: today, 12:36  UTC")
                    .font(.neueMontreal(size: 11))
                    .foregroundStyle(.ghostWhite800)
            }
            .padding(.horizontal, 16)
            
            LazyVStack(spacing: 0) {
                rankListHeaderView
                
                ForEach(rankMocks, id: \.rank) { leaderBoardRankViewModel in
                    createRankListCell(with: leaderBoardRankViewModel)
                }
            }
        }
    }
    
    @ViewBuilder
    var rulesView: some View {
        Group {
            Color(.ghostWhite200)
                .frame(maxWidth: .infinity)
                .frame(height: 2)
                .padding(.top, 24)
            
            Markdown(StringRepository.hiveLeaderboardRules.getString())
                .markdownBlockStyle(\.heading2) { configuration in
                    configuration.label
                        .markdownMargin(top: 32, bottom: 12)
                        .markdownTextStyle {
                            FontSize(24)
                            ForegroundColor(.white)
                            FontFamily(.custom(FontStyle.foundersGroteskFontFamily[.semibold] ?? ""))
                        }
                }
                .markdownTextStyle(\.strong) {
                    FontSize(14)
                    FontWeight(.black)
                    ForegroundColor(.white)
                    FontFamily(.custom(FontStyle.neueMontrealFontFamilty[.regular] ?? ""))
                }
                .markdownTextStyle {
                    FontSize(14)
                    FontWeight(.regular)
                    ForegroundColor(.appCream)
                    FontFamily(.custom(FontStyle.neueMontrealFontFamilty[.regular] ?? ""))
                }
                .padding(.vertical, 32)
            
            Color(.ghostWhite200)
                .frame(maxWidth: .infinity)
                .frame(height: 2)
                    .padding(.bottom, 24)
            
            VStack {
                Text("Top the leaderboard and win the prize pool. Lorem ipsum dolor sit amet lorem ipsum dolor sit ametlorem ipsum dolor sit ametlorem")
                    .font(.neueMontreal(size: 12))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                    .frame(height: 48)
                    .padding(24)
                
                CommonButton.basic(.rectangle, title: "LEARN MORE ABOUT BYTES HIVE", foregroundColor: .byteBlack1000, backgroundColor: HiveColors.mainYellow) {
                    if let url = URL(string: "https://bythen-ai.gitbook.io/byteshive-guide") {
                        openURL(url)
                    }
                }
                .padding(.horizontal, 60)
                .padding(.bottom, 24)
            }
            .background(
                Rectangle()
                    .fill(.ghostWhite100)
                    .border(.ghostWhite200)
            )
        }
        .padding(.horizontal, 16)
    }
    
    var body: some View {
        ScrollView {
            headerView
            
            tabButton
            
            if selectedTab == .rank {
                rankListView
            } else {
                rulesView
            }
        }
        .embedHiveNavigationBar()
        .background(.black)
        .transition(.slide)
        .animation(.easeIn(duration: 0.25), value: selectedTab)
    }
    
    private func createChevronButton(_ isNext: Bool = false) -> some View {
        Button  {
            print("\(isNext ? "next" : "prev") month")
        } label: {
            Image(systemName: "chevron.\(isNext ? "right" : "left")")
                .foregroundStyle(.ghostWhite700)
        }
        .frame(square: 25)
    }
    
    private func createRankListCell(with viewModel: HiveLeaderboardRankViewModel) -> some View {
        HStack(spacing: 0) {
            Group {
                let isTopThree = viewModel.rank < 4
                
                Group {
                    if isTopThree {
                        Image(systemName: "crown.fill")
                            .foregroundStyle(HiveColors.mainYellow)
                            .shadow(color: HiveColors.mainYellow, radius: 4)
                    } else {
                        Text("1")
                            .foregroundStyle(.white)
                    }
                }
                .frame(maxWidth: 56, alignment: .center)
                
                Text("sharkie_daddy")
                    .foregroundStyle(isTopThree ? HiveColors.mainYellow : .white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                    .conditionalModifier(isTopThree) { view in
                        view
                            .shadow(color: HiveColors.mainYellow, radius: 4)
                    }
                
                Text("1523")
                    .foregroundStyle(.white)
                    .frame(width: 97, alignment: .center)
            }
            .font(.dmMono(.semibold))
            .foregroundStyle(.white)
            // TODO: hide background when its not top three
            .padding(.vertical, 22)
            .background(.ghostWhite300.opacity(0.2))
        }
        .background(
            Rectangle().border(.ghostWhite300, width: 1)
        )
        .padding(.horizontal, 16)
    }
}
