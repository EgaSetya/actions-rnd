//
//  HiveDashboardBottomSheetProgressSection.swift
//  Bythen
//
//  Created by Darindra R on 22/11/24.
//

import SwiftUI

struct HiveDashboardBottomSheetProgressSection: View {
    @Environment(\.openURL) var openURL
    @ObservedObject
    var viewModel: HiveDashboardBottomSheetViewModel
    
    @State
    private var beaconPosition: [Int: CGFloat] = [:]
    
    private var rankProgressionCellLinearGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                .white.opacity(0.1),
                .gray.opacity(0.05),
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("RANK PROGRESSION")
                        .font(FontStyle.foundersGrotesk(.semibold, size: 14))
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Text("\(viewModel.displayBeaconPoints)/\(viewModel.maxProgressSlot) Slots")
                        .font(FontStyle.dmMono(.medium, size: 11))
                        .foregroundStyle(.white)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Grid(horizontalSpacing: 8) {
                        GridRow {
                            ForEach(1 ... viewModel.maxProgressSlot, id: \.self) { index in
                                createRankProgressionCell(for: index)
                            }
                        }
                    }
                    
                    crateRankCaption()
                }
            }
            
            Button(
                action: {
                    if let url = URL(string: "https://bythen-ai.gitbook.io/byteshive-guide/how-to-join-bytes-hive/bytes-hive-membership-status") {
                        openURL(url)
                    }
                }
            ) {
                Text("Learn about Rank & Rewards")
                    .font(FontStyle.neueMontreal(.regular, size: 12))
                    .foregroundStyle(HiveColors.mainYellow)
            }
        }
    }
    
    private func createRankProgressionCell(for index: Int) -> some View {
        VStack {
            if viewModel.rank.isTrial {
                rankProgressionCellLinearGradient.conditionalModifier(index == 1) { view in
                    view.background(
                        RoundedRectangle(cornerRadius: 8).stroke(HiveColors.mainYellow, lineWidth: 2)
                    )
                }
            } else {
                if viewModel.rank.activeStatus, index <= viewModel.rank.beaconPoints {
                    HiveColors.mainYellow
                } else {
                    rankProgressionCellLinearGradient
                }
            }
        }
        .frame(height: 48)
        .cornerRadius(8, corners: .allCorners)
        .overlay {
            if let rule = viewModel.progressRules["\(index)"] {
                AsyncImage(url: URL(string: rule.iconURL)) { phase in
                    if case let .success(image) = phase {
                        image
                            .resizable()
                            .conditionalModifier(index > viewModel.rank.beaconPoints) { view in
                                view
                                    .renderingMode(.template)
                                    .foregroundStyle(viewModel.rank.isTrial ? HiveColors.mainYellow : .ghostWhite300)
                            }
                            .scaledToFit()
                            .padding(.horizontal, 4)
                    }
                }
            }
        }
        .overlay {
            GeometryReader { proxy in
                Color.clear.onAppear {
                    if index == viewModel.maxProgressSlot {
                        beaconPosition[index] = proxy.frame(in: .global).maxX
                    } else {
                        beaconPosition[index] = proxy.frame(in: .global).minX
                    }
                }
            }
        }
        .overlay(alignment: .topLeading) {
            if let rule = viewModel.progressRules["\(index)"], rule.showStar {
                Image(AppImages.kTopStarIcon)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 18, height: 18)
                    .offset(x: -8, y: -6)
            }
        }
        .overlay(alignment: .bottomTrailing) {
            if let rule = viewModel.progressRules["\(index)"], rule.showStar {
                Image(AppImages.kBottomStarIcon)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 12, height: 12)
                    .offset(x: 4, y: 4)
            }
        }
    }
    
    private func crateRankCaption() -> some View {
        ZStack {
            ForEach(Array(beaconPosition.keys), id: \.self) { key in
                if let rule = viewModel.progressRules["\(key)"], let position = beaconPosition[key] {
                    VStack(alignment: key == viewModel.maxProgressSlot ? .trailing : .leading, spacing: 2) {
                        Text(rule.tierName)
                            .font(FontStyle.neueMontreal(.bold, size: 8))
                            .foregroundStyle(HiveColors.mainYellow)
                        
                        Text(rule.bonusCaption)
                            .multilineTextAlignment(key == viewModel.maxProgressSlot ? .trailing : .leading)
                            .font(FontStyle.neueMontreal(.regular, size: 8))
                            .foregroundStyle(.white)
                            .lineLimit(2)
                    }
                    .offset(x: rankCaptionPosition(key, position: position))
                }
            }
        }
    }
    
    private func rankCaptionPosition(_ key: Int, position: CGFloat) -> CGFloat {
        key == viewModel.maxProgressSlot ? position - 46 - 48 : position - 24.0
    }
}
