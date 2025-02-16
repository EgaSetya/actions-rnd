//
//  ThreeDotsLoader.swift
//  Bythen
//
//  Created by Darindra R on 27/09/24.
//

import SwiftUI

struct ThreeDotsLoader: View {
    @State var loading = false

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(.appBlack)
                .frame(width: 8, height: 8)
                .scaleEffect(loading ? 1 : 0.5)
                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: loading)
            Circle()
                .fill(.appBlack)
                .frame(width: 8, height: 8)
                .scaleEffect(loading ? 1 : 0.5)
                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true).delay(0.2), value: loading)
            Circle()
                .fill(.appBlack)
                .frame(width: 8, height: 8)
                .scaleEffect(loading ? 1 : 0.5)
                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true).delay(0.4), value: loading)
        }
        .onAppear {
            self.loading = true
        }
    }
}
