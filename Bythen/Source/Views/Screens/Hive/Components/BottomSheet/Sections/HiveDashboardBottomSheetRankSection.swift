//
//  HiveDashboardBottomSheetRankSection.swift
//  Bythen
//
//  Created by Darindra R on 22/11/24.
//

import SwiftUI

struct HiveDashboardBottomSheetRankSection: View {
    @ObservedObject
    var viewModel: HiveDashboardBottomSheetViewModel

    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .center, spacing: 4) {
                    ZStack {
                        if let account = viewModel.account, account.profileImageUrl.isNotEmpty {
                            CachedAsyncImage(urlString: account.profileImageUrl)
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
                    .frame(width: 43.28, height: 49.05)

                    Text(viewModel.username)
                        .font(FontStyle.neueMontreal(.medium, size: 8))
                        .foregroundStyle(.ghostWhite300)
                }

                VStack(alignment: .leading, spacing: 0) {
                    Text("YOUR RANK")
                        .font(FontStyle.dmMono(.medium, size: 8))
                        .foregroundStyle(.ghostWhite300)

                    Text(viewModel.rank.tierName.isEmpty ? "--" : viewModel.rank.tierName)
                        .font(FontStyle.foundersGrotesk(.semibold, size: 18))
                        .foregroundStyle(.white)
                }
            }

            HStack {
                VStack(alignment: .center, spacing: 4) {
                    Text(viewModel.directCommisionPercentage)
                        .font(FontStyle.foundersGrotesk(.semibold, size: 18))
                        .foregroundStyle(.white)

                    Text("DIRECT REWARD")
                        .font(FontStyle.dmMono(.medium, size: 8))
                        .foregroundStyle(.ghostWhite300)
                }

                Spacer()

                VStack(alignment: .center, spacing: 4) {
                    Text(viewModel.passupCommissionPercentage)
                        .font(FontStyle.foundersGrotesk(.semibold, size: 18))
                        .foregroundStyle(.white)

                    Text("PASS UP BONUS")
                        .font(FontStyle.dmMono(.medium, size: 8))
                        .foregroundStyle(.ghostWhite300)
                }

                Spacer()

                VStack(alignment: .center, spacing: 4) {
                    Text(viewModel.pairingCommissionPercentage)
                        .font(FontStyle.foundersGrotesk(.semibold, size: 18))
                        .foregroundStyle(.white)

                    Text("PAIRING BONUS")
                        .font(FontStyle.dmMono(.medium, size: 8))
                        .foregroundStyle(.ghostWhite300)
                }
            }
        }
        .padding(.all, 16)
        .background {
            Image("hive-pattern")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
