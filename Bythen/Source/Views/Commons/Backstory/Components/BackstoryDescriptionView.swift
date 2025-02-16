//
//  BackstoryDescriptionView.swift
//  Bythen
//
//  Created by Darindra R on 22/10/24.
//

import SwiftUI

struct BackstoryDescriptionView: View {
    @FocusState
    private var isFocused: Bool

    @Binding var description: String

    var didTapSave: (String) -> Void

    var body: some View {
        VStack(spacing: 0) {
            TextEditor(text: $description)
                .font(FontStyle.secondFont(.regular, size: 14))
                .tint(Color(hex: "#F04406"))
                .overlay(alignment: .topLeading) {
                    Text("Use this section to add any intriguing backstory about your character, such as their origin, hobbies, interests, or cultural experiences that shaped who they are today.")
                        .font(FontStyle.secondFont(.regular, size: 14))
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

            BasicSquareButton(title: "SAVE DESCRIPTION") {
                didTapSave(description)
            }
            .padding(.all, 16)
        }
    }
}
