//
//  CommonButton.swift
//  Bythen
//
//  Created by Ega Setya on 12/12/24.
//

import SwiftUI

struct CommonButton<Content>: View where Content: View {
    var content: Content
    
    var body: some View {
        content
    }
}

extension CommonButton where Content == BasicButton {
    static func basic(
        _ type: BasicButtonType,
        title: String,
        colorScheme: ColorScheme = .light,
        foregroundColor: Color? = nil,
        backgroundColor: Color? = nil,
        isDisabled: Binding<Bool> = .constant(false),
        onTap: @escaping (() -> Void)
    ) -> BasicButton {
        BasicButton(
            type: type,
            title: title,
            colorScheme: colorScheme,
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
            isDisabled: isDisabled,
            onTap: onTap
        )
    }
}

extension CommonButton where Content == TextIconButton {
    static func textIcon(_ type: TextIconButtonType, title: String, font: Font? = nil, colorScheme: ColorScheme = .dark, fillWidth: Bool = false, enabledBackgroundColor: Color? = nil, isDisabled: Binding<Bool> = .constant(false), onTap: @escaping (() -> Void)) -> some View {
        Self(content: TextIconButton(type: type, title: title, font: font, colorScheme: colorScheme, fillWidth: fillWidth, enabledBackgroundColor: enabledBackgroundColor, isDisabled: isDisabled, onTap: onTap))
    }
}
