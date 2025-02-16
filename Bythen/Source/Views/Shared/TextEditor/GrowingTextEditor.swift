//
//  GrowingTextView.swift
//  Bythen
//
//  Created by Darindra R on 21/09/24.
//

import SwiftUI

struct GrowingTextEditor: UIViewRepresentable {
    @Binding var text: String
    @Binding var height: CGFloat
    @Binding var isFocused: Bool

    var maxHeight: CGFloat

    init(
        text: Binding<String>,
        height: Binding<CGFloat>,
        isFocused: Binding<Bool>,
        maxHeight: CGFloat = 80
    ) {
        _text = text
        _height = height
        _isFocused = isFocused
        self.maxHeight = maxHeight
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.delegate = context.coordinator
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.autocorrectionType = .default
        textView.autocapitalizationType = .sentences

        if let font = FontStyle.neueMontrealFontFamilty[.regular] {
            textView.font = UIFont(name: font, size: 14)
        }

        return textView
    }

    func updateUIView(_ uiView: UITextView, context _: Context) {
        uiView.text = text

        if isFocused {
            uiView.becomeFirstResponder()
        } else {
            uiView.resignFirstResponder()
        }

        updateViewHeight(uiView)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    private func updateViewHeight(_ uiView: UITextView) {
        DispatchQueue.main.async {
            let size = uiView.sizeThatFits(
                CGSize(
                    width: uiView.frame.width,
                    height: CGFloat.greatestFiniteMagnitude
                )
            )

            if size.height != self.height {
                uiView.isScrollEnabled = size.height > maxHeight
                self.height = min(size.height, maxHeight)
            }
        }
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: GrowingTextEditor

        init(_ parent: GrowingTextEditor) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.parent.text = textView.text
            }
        }

        func textViewDidBeginEditing(_: UITextView) {
            DispatchQueue.main.async {
                self.parent.isFocused = true
            }
        }

        func textViewDidEndEditing(_: UITextView) {
            DispatchQueue.main.async {
                self.parent.isFocused = false
            }
        }
    }
}
