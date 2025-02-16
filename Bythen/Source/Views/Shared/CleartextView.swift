//
//  CleartextView.swift
//  Bythen
//
//  Created by edisurata on 03/09/24.
//

import Foundation
import SwiftUI

struct ClearTextView: UIViewRepresentable {
    @Binding var text: String
    var font: UIFont
    var textColor: UIColor

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = font
        textView.textColor = textColor
        textView.backgroundColor = .clear // Set the background color to clear
        textView.delegate = context.coordinator
        textView.isScrollEnabled = true
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: ClearTextView

        init(_ parent: ClearTextView) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
}
