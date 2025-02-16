//
//  HiveDashboardBottomSheet.swift
//  Bythen
//
//  Created by Darindra R on 22/11/24.
//

import SwiftUI

struct HiveDashboardBottomSheet: View {
    @Environment(\.safeAreaInsets)
    private var safeAreaInsets

    @StateObject
    var viewModel: HiveDashboardBottomSheetViewModel

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.appBlack.opacity(0.7)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.dismissView()
                    }
                }

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Spacer()
                    Image("white-close")
                        .frame(width: 13.5, height: 13.5)
                        .foregroundStyle(.white)
                        .padding(.all, 11.25)
                        .background(.appDarkGray)
                        .clipShape(Circle())
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                viewModel.dismissView()
                            }
                        }
                }
                .padding(.horizontal, 12)

                VStack(alignment: .leading, spacing: 24) {
                    HiveDashboardBottomSheetTitleSection(
                        isTrial: viewModel.rank.isTrial,
                        isActive: viewModel.rank.activeStatus
                    )

                    HiveDashboardBottomSheetRankSection(viewModel: viewModel)
                    HiveDashboardBottomSheetByteSection(products: viewModel.products)
                    HiveDashboardBottomSheetProgressSection(viewModel: viewModel)
                }
                .padding([.top, .horizontal], 24)
                .padding(.bottom, safeAreaInsets.bottom + 24)
                .background(.black)
                .cornerRadius(8, corners: [.topLeft, .topRight])
            }
            .task {
                await viewModel.onAppear()
            }
        }
        .edgesIgnoringSafeArea(.all)
        .background(.clear)
    }
}
