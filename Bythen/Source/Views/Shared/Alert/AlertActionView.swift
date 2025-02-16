//
//  AlertActionView.swift
//  Bythen
//
//  Created by Darindra R on 12/11/24.
//

import Combine
import SwiftUI

struct AlertActionView: View {
    @Binding
    var isPresented: Bool
    let isAutoClose: Bool
    let title: String
    let description: String
    let actionTitle: String
    let action: () -> Void

    @State private var cancellable: AnyCancellable?

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Image(AppImages.kAlertIconFill)
                .resizable()
                .frame(width: 20, height: 20)
                .padding(.all, 12)

            VStack(alignment: .leading, spacing: 2) {
                Text("**\(title):** \(description)")
                    .font(FontStyle.neueMontreal(.regular, size: 12))

                Text(actionTitle)
                    .font(FontStyle.neueMontreal(.regular, size: 12))
                    .underline()
                    .onTapGesture {
                        action()
                    }
            }
            .padding(.trailing, 8)

            Divider()
                .frame(width: 1, height: 44)

            Image(systemName: "xmark")
                .resizable()
                .frame(width: 12, height: 12)
                .padding(.all, 12)
                .onTapGesture {
                    toggleCloseButton()
                }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .background(Color(hex: "#FFDDDD"))
        .padding(.all, 16)
        .transition(.move(edge: .trailing))
        .onAppear {
            if isAutoClose {
                startCloseButtonAutoDismiss()
            }
        }
    }

    private func toggleCloseButton() {
        isPresented.toggle()
        cancellable?.cancel()
    }

    private func startCloseButtonAutoDismiss() {
        cancellable?.cancel()
        cancellable = Timer.publish(every: 3, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                withAnimation {
                    isPresented.toggle()
                }
                cancellable?.cancel()
            }
    }
}
