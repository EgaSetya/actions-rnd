//
//  DojoStudioBackstoryView.swift
//  Bythen
//
//  Created by Darindra R on 06/11/24.
//

import SwiftUI

struct DojoStudioBackstoryView: View {
    @Environment(\.dismiss)
    private var dismiss

    @State
    private var shouldShowAlert: Bool = false

    @State
    private var script: String = ""
    private let initialScript: String
    private let onFinishEditing: (String) -> Void

    init(
        script: String,
        onFinishEditing: @escaping (String) -> Void
    ) {
        self.script = script
        initialScript = script
        self.onFinishEditing = onFinishEditing
    }

    var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(
                action: {
                    if script == initialScript || script.isEmpty {
                        dismiss()
                    } else {
                        shouldShowAlert = true
                    }
                }
            ) {
                Image(systemName: "xmark")
                    .frame(width: 24, height: 24)
            }
            .tint(.white)

            HStack(alignment: .center) {
                Text("Script")
                    .font(FontStyle.foundersGrotesk(.medium, size: 28))
                    .foregroundColor(.white)

                Spacer()

                Text("\(script.count)/1000 Characters")
                    .font(FontStyle.neueMontreal(.medium, size: 12))
                    .foregroundStyle(script.count == 1000 ? .appRed : .ghostWhite300)
            }
        }
        .contentShape(Rectangle())
        .padding(.all, 16)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header

            DojoStudioDescriptionView(description: $script) {
                onFinishEditing(script)
            }
        }
        .background(.black)
        .onTapGesture {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil,
                from: nil,
                for: nil
            )
        }
        .alert(
            "You have unsaved changes!",
            isPresented: $shouldShowAlert,
            actions: {
                Button("Save & Exit") {
                    onFinishEditing(script)
                }
                .keyboardShortcut(.defaultAction)

                Button("Exit Without Saving") {
                    shouldShowAlert = false
                    dismiss()
                }

                Button("Cancel") {
                    shouldShowAlert = false
                }
            },
            message: {
                Text("It looks like you've made some changes that haven’t been saved yet. If you close now, you’ll lose any unsaved progress.")
            }
        )
    }
}
