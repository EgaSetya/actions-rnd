//
//  DojoStudioDescriptionView.swift
//  Bythen
//
//  Created by Darindra R on 06/11/24.
//

import SwiftUI

struct DojoStudioDescriptionView: View {
    @FocusState
    private var isFocused: Bool

    @Binding
    var description: String
    var action: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            TextEditor(
                text: Binding(
                    get: { description },
                    set: { value in
                        if value.count <= 1000 {
                            description = value
                        }
                    }
                )
            )
            .font(FontStyle.neueMontreal(.regular, size: 14))
            .tint(Color(hex: "#F04406"))
            .overlay(alignment: .topLeading) {
                Text("Use this section to add any intriguing backstory about your character, such as their origin, hobbies, interests, or cultural experiences that shaped who they are today.")
                    .font(FontStyle.neueMontreal(.regular, size: 14))
                    .padding(.top, 8)
                    .padding(.leading, 4)
                    .foregroundColor(Color(hex: "#8A8378"))
                    .isHidden(!description.isEmpty)
                    .allowsHitTesting(false)
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 16)
            .scrollDisabled(description.isEmpty)
            .focused($isFocused)

            BasicSquareButton(title: "ADD SCRIPT", background: .white, foregroundColor: .black) {
                action()
            }
            .padding(.all, 16)
        }
        .colorScheme(.dark)
    }
}
