//
//  AlertView.swift
//  Bythen
//
//  Created by edisurata on 19/09/24.
//

import SwiftUI

struct ErrorTickerView: View {
    @Binding var isPresent: Bool
    let message: String

    var body: some View {
        HStack {
            Image("info.fill")
                .resizable()
                .renderingMode(.template)
                .frame(width: 14, height: 14)
                .foregroundStyle(.gokuOrange600)
                .padding(.leading, 12)
                .padding(.vertical, 11)
            Text(message)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.appBlack)
                .font(FontStyle.dmMono(.medium, size: 11))
                .lineSpacing(5)
                .padding(.vertical, 10)
            Button(action: {
                isPresent = false
            }, label: {
                Image("close")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.byteBlack)
                    .frame(width: 10, height: 10)
                    .padding(.vertical, 12)
                    .padding(.trailing, 4)
            })

            Spacer()
        }
        .background(.gokuOrange100)
        .border(.gokuOrange400, width: 1)
        .transition(.slide)
        .animation(.easeInOut, value: message)
    }
}

#Preview {
    ErrorTickerView(
        isPresent: .constant(true),
        message: "AN ERROR OCCURRED. PLEASE TRY AGAIN."
    )
}
