//
//  ByteGifView.swift
//  Bythen
//
//  Created by erlina ng on 24/11/24.
//

import SwiftUI
import WebKit

struct ByteGifView: UIViewRepresentable {
    private let name: String
    
    init(_ name: String) {
        self.name = name
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webview = WKWebView()
        let url = Bundle.main.url(forResource: name, withExtension: "gif")
        
        guard let url else { return webview }
        
        let data = try! Data(contentsOf: url)
        
        webview.load(
            data,
            mimeType: "image/gif",
            characterEncodingName: "UTF-8",
            baseURL: url.deletingLastPathComponent()
        )
        return webview
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.reload()
    }
}
