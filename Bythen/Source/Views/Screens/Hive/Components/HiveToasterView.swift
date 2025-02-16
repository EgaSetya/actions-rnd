//
//  HiveToasterView.swift
//  Bythen
//
//  Created by erlina ng on 18/12/24.
//

import SwiftUI

struct HiveToasterView: View {
    var text = "COPY CODE SUCCESSFUL"
    var closeDidTap: (() -> Void)?
    
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(Color.appGreen)
                .scaledToFit()
                .frame(height: 14)
            
            Spacer()
            
            Text(text)
                .font(FontStyle.dmMono(.medium, size: 11))
                .foregroundStyle(Color.white)
                .lineLimit(2)
            
            Spacer()
            
            Button {
                closeDidTap?()
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.white)
                    .scaledToFit()
                    .frame(height: 10)
            }
            .padding(10)
            .contentShape(Rectangle())

        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark)))
        .border(Color.white, width: 1)
    }
}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}
