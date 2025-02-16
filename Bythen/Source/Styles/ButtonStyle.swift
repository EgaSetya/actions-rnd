//
//  ButtonStyle.swift
//  Bythen
//
//  Created by edisurata on 14/09/24.
//

import SwiftUI

struct CircularButtonStyle: ViewModifier {
    var imageName: String
    var backgroundColor: Color = .white
    var isEnableTint: Bool = false
    var tintColor: Color = .clear
    var action: () -> Void = {}
    
    func body(content: Content) -> some View {
        content
            .background(backgroundColor)
            .clipShape(Circle())
    }
}
