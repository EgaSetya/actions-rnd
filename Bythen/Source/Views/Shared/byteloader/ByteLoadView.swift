//
//  ByteLoadView.swift
//  Bythen
//
//  Created by Darindra R on 03/10/24.
//

import SwiftUI

struct ByteLoadView: View {
    @Binding var isCompleted: Bool
    @Binding var byteName: String
    let completion: () -> Void

    var body: some View {
        VStack(alignment: .center) {

            Spacer()

            ByteLoadProgressView(isCompleted: $isCompleted, byteName: $byteName) {
                completion()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color(hex: "#FF8237"))
        .overlay(alignment: .center) {
            ByteCircleLoadView()
        }
    }
}
