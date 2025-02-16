//
//  ChatSearchView.swift
//  Bythen
//
//  Created by Darindra R on 10/10/24.
//

import SwiftUI

struct ChatSearchView: View {
    let data: [ChatDataURL]

    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            ForEach(data, id: \.self) { data in
                HStack(alignment: .top, spacing: 8) {
                    AsyncImage(url: URL(string: data.icon)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    } placeholder: {
                        Image(AppImages.kBrowsingIcon)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 20, height: 20)
                    }

                    VStack(alignment: .leading, spacing: 0) {
                        Text(data.name)
                            .lineLimit(1)
                            .font(FontStyle.neueMontreal(.medium, size: 14))
                            .foregroundStyle(.appBlack)

                        Text(data.baseURL)
                            .lineLimit(1)
                            .font(FontStyle.neueMontreal(.regular, size: 14))
                            .foregroundStyle(.appBlack.opacity(0.5))
                    }

                    Spacer()
                }
                .padding(.all, 12)
                .background(.white)
                .contentShape(Rectangle())
                .onTapGesture {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.prepare()
                    generator.impactOccurred()

                    if let url = URL(string: data.url) {
                        UIApplication.shared.open(url)
                    }
                }
            }
        }
    }
}
