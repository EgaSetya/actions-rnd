//
//  CustomWebView.swift
//  Bythen
//
//  Created by Ega Setya on 20/01/25.
//

import SwiftUI
import WebKit

// WebView Representable
struct WebView: UIViewRepresentable {
    let url: URL
    var cookieValues = [String: Any]()
    @Binding var isPageLoaded: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.overrideUserInterfaceStyle = .dark
        webView.navigationDelegate = context.coordinator
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: cookieValues, options: []),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            
            let cookie = HTTPCookie(properties: [
                .domain: url.host ?? "",
                .path: "/",
                .name: "BYTHEN_AUTH",
                .value: jsonString,
                .secure: "FALSE"
            ])
            
            if let cookie = cookie {
                webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
            }
        }

        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            self.parent.isPageLoaded = true
        }
    }
}


struct CustomWebView: View {
    var url: URL?
    var cookies = [String: Any]()
    var title = ""
    var didTapCloseButton: (() -> Void)?
    @State private var isPageLoaded = false
    
    var body: some View {
        WebView(
            url: url!,
            cookieValues: cookies,
            isPageLoaded: $isPageLoaded
        )
        .safeAreaInset(edge: .bottom) {
            Color.appBlack
                .frame(height: 40)
        }
        .safeAreaInset(edge: .top) {
            HStack {
                Button {
                    didTapCloseButton?()
                } label: {
                    Image(.whiteClose)
                        .renderingMode(.template)
                        .resizable()
                        .frame(square: 24)
                        .foregroundStyle(.white)
                }
                
                Spacer()
            }
            .overlay {
                Text(title)
                    .frame(alignment: .center)
                    .font(.foundersGrotesk(.semibold, size: 16))
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .padding(.horizontal, 24)
        }
        .background(.appBlack)
        .ignoresSafeArea(edges: [.bottom])
        .overlay {
            if !isPageLoaded {
                ZStack {
                    Color.appBlack // Background color
                        .ignoresSafeArea() // Extend to cover safe areas
                    
                    NetworkProgressView(size: 30)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}
