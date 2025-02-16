//
//  Banner.swift
//  Bythen
//
//  Created by Ega Setya on 09/12/24.
//

import SwiftUI

struct Banner<Content>: View where Content: View {
    private let content: Content
    
    var body: some View {
        content
    }
}

extension Banner where Content == DialogView {
    static func dialog(type: DialogType, text: String, showCloseButton: Bool? = nil, isPresented: Binding<Bool> = .constant(false)) -> some View {
        Self(content: DialogView(type: type, text: text, showCloseButton: showCloseButton == nil ? false : showCloseButton ?? false, isPresented: isPresented))
    }
}

extension Banner where Content == StaticView {
    static func `static`(text: String, closeAction: (() -> Void)? = nil) -> some View {
        Self(content: StaticView(text: text, closeAction: closeAction))
    }
}

extension Banner {
    static func customView(_ view: Content) -> some View {
        Self(content: view)
    }
}

struct ContentPreview: View {
    @State private var showDialog = false
    @Environment(\.safeAreaInsets) var safeAreaInsets

    var body: some View {
        ZStack {
            VStack {
                Button("Show Dialog") {
                    withAnimation {
                        showDialog = true
                    }
                }
            }
            
            Banner.dialog(
                type: .error,
                text: "Failed to upload Profile Picture\nSomething went wrong. Please try again.",
                showCloseButton: true,
                isPresented: $showDialog
            )
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    ContentPreview()
}
