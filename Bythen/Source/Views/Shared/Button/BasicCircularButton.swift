//
//  BasicCircularButton.swift
//  Bythen
//
//  Created by Darindra R on 19/09/24.
//

import SwiftUI

struct BasicCircularButton: View {
    private var imageName: String
    private var systemName: String
    private var iconSize: (width: CGFloat, height: CGFloat)
    private var action: () -> Void = {}

    private var backgroundColor: Color = .clear
    private var foregroundColor: Color = .appBlack
    private var image: Image {
        if systemName.isTrulyEmpty {
            return Image(imageName)
        }
        
        return Image(systemName: systemName)
    }

    init(
        image: String = "",
        systemName: String = "",
        iconSize: (width: CGFloat, height: CGFloat) = (24, 24),
        action: @escaping () -> Void = {}
    ) {
        self.imageName = image
        self.systemName = systemName
        self.iconSize = iconSize
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            image
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(foregroundColor)
                .frame(width: iconSize.width, height: iconSize.height)
        }
        .padding(.all, 12)
        .background(backgroundColor)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(.appBlack, lineWidth: 1)
        )
    }
}

extension BasicCircularButton {
    func backgroundColor(_ color: Color) -> Self {
        var view = self
        view.backgroundColor = color
        return view
    }

    func foregroundColor(_ color: Color) -> Self {
        var view = self
        view.foregroundColor = color
        return view
    }
}

#Preview {
    BasicCircularButton(image: AppImages.kAttachmentIcon)
        .padding()
}
