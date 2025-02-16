//
//  HiveDashboardBottomSheetByteSection.swift
//  Bythen
//
//  Created by Darindra R on 22/11/24.
//

import SwiftUI

struct HiveDashboardBottomSheetByteSection: View {
    let products: [HiveProduct]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Inventory")
                    .font(FontStyle.dmMono(.medium, size: 12))
                    .foregroundStyle(.ghostWhite300)

                Spacer()

                Text("\(products.count) Items")
                    .font(FontStyle.dmMono(.medium))
                    .foregroundStyle(.white)
            }

            if products.isEmpty {
                VStack(alignment: .center, spacing: 8) {
                    Image("hive-empty-product")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 24, height: 24)

                    Text("Your inventory is empty. Visit our store website to find what you need and get started")
                        .multilineTextAlignment(.center)
                        .font(FontStyle.neueMontreal(size: 12))
                        .foregroundStyle(.ghostWhite300)
                }
                .padding(.top, 8)
                .padding(.horizontal, 24)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 8) {
                        ForEach(products, id: \.id) { product in
                            HiveDashboardCollectionCard(data: product.data)
                        }
                    }
                    .padding(.all, 1)
                }
            }
        }
    }
}
