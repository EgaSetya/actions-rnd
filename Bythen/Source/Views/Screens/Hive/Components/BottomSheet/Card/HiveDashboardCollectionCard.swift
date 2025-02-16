//
//  HiveDashboardCollectionCard.swift
//  Bythen
//
//  Created by Darindra R on 22/11/24.
//

import SwiftUI

struct HiveDashboardCollectionCard: View {
    let data: HiveProductData

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            CachedAsyncImage(urlString: data.iconURL)
                .frame(width: 40, height: 40)
                .padding(.all, 10)
                .overlay(
                    Rectangle().stroke(.ghostWhite300, lineWidth: 1)
                )

            HStack(alignment: .center, spacing: 4) {
                HiveColors.mainYellow
                    .frame(width: 4, height: 7.25)

                Text("\(data.slot) Slot")
                    .font(FontStyle.dmMono(.regular, size: 8))
                    .foregroundStyle(.white)
            }
        }
    }
}
