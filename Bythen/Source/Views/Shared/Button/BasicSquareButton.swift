//
//  PrimaryButton.swift
//  Bythen
//
//  Created by edisurata on 30/08/24.
//

import SwiftUI

struct BasicSquareButton: View {
    
    var title: String
    var fontSize: CGFloat = 18
    var background: Color = .black
    var foregroundColor: Color = .white
    var cornerRadius: CGFloat = 0
    var isEnableTint: Bool = false
    var leftIconName: String?
    var rightIconName: String?
    var action: () -> Void = {}
    
    @Environment(\.isEnabled) private var isEnabled
    
    var body: some View {
        Button(action: {
            if isEnabled {
                action()
            }
        }) {
            HStack {
                if let imageName = leftIconName {
                    Image(imageName)
                        .frame(width: 20, height: 20)
                        .padding()
                        .tint(isEnabled ? .clear : .appBlack.opacity(0.1))
                } else {
                    Spacer(minLength: 50)
                }
                
                Text(title)
                    .foregroundStyle(isEnabled ? foregroundColor
                                     : .appBlack.opacity(0.3))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .font(FontStyle.foundersGrotesk(.semibold, size: fontSize))
                
                if let imageName = rightIconName {
                    if isEnableTint {
                        Image(uiImage: UIImage(named: imageName)!.withRenderingMode(.alwaysTemplate))
                            .padding()
                            .tint(isEnabled ? foregroundColor : foregroundColor.opacity(0.1))
                    } else {
                        Image(imageName)
                            .frame(width: 20, height: 20)
                            .padding()
                    }
                } else {
                    Spacer(minLength: 50)
                }
            }
        }
        .background(isEnabled ? background : .appBlack.opacity(0.1))
        .frame(maxWidth: .infinity)
        .buttonStyle(.borderless)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .disabled(!isEnabled)
    }
}

#Preview {
    BasicSquareButton(title: "Primary Button", action: {})
}
