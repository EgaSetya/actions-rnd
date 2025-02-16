//
//  MissionWebView.swift
//  Bythen
//
//  Created by Darul Firmansyah on 22/01/25.
//

import SwiftUI
import WebKit

struct MissionConstant {
    static let baseURL: String = "https://local.bythen.ai:3001"
    static let twitterAuthDeniedURL: String = baseURL + "/twitter-auth?denied"
    static let twitterAuthURI: String = baseURL + "/twitter-auth"
    static let twitterPostURL: String = "https://mobile.twitter.com/i/web/status/%@"
    static let kAuthToken: String = "oauth_token"
    static let kAuthVerifier: String = "oauth_verifier"
}

struct MissionWebViewContainer: View {
    @Binding var showWebView: Bool
    let url: URL
    var delegate: MissionWebViewDelegate?

    var body: some View {
        NavigationView {
            VStack {
                MissionWebView(url: url, delegate: delegate)
            }
            .navigationBarItems(leading: Button {
                dismiss()
                delegate?.onCancel()
            } label: {
                Image(systemName: "xmark")
                    .font(.headline)
            })
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func dismiss() {
        showWebView = false
    }
}

protocol MissionWebViewDelegate {
    func onAuthorized(oauthToken: String, oauthVerifier: String)
    func onCancel()
    func onRejected()
}

struct MissionWebView: UIViewRepresentable {
    let url: URL
    var delegate: MissionWebViewDelegate?

    func makeCoordinator() -> Coordinator {
        return Coordinator(self, delegate: delegate)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator // Set the navigation delegate
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: MissionWebView
        var delegate: MissionWebViewDelegate?

        init(_ parent: MissionWebView, delegate: MissionWebViewDelegate?) {
            self.parent = parent
            self.delegate = delegate
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url {
                let queryParam = getQueryParams(from: url.absoluteString)
                if let authToken = queryParam[MissionConstant.kAuthToken],
                   let authVerifier = queryParam[MissionConstant.kAuthVerifier] {
                    delegate?.onAuthorized(oauthToken: authToken, oauthVerifier: authVerifier)
                    decisionHandler(.cancel)
                    return
                }
                else if url.absoluteString.contains(MissionConstant.twitterAuthDeniedURL) {
                    delegate?.onRejected()
                    decisionHandler(.cancel)
                    return
                }
                
                decisionHandler(.allow)
            } else {
                decisionHandler(.cancel)
            }
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            // TODO: Darul, start loading info
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // TODO: Darul, finished loading info
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("Failed to load: \(error.localizedDescription)")
        }
        
        private func getQueryParams(from urlString: String) -> [String: String] {
            guard let url = URL(string: urlString) else {
                return [:]
            }
            
            guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                return [:]
            }
            
            let queryItems = components.queryItems ?? []
            var queryParams = [String: String]()
            for item in queryItems {
                if let value = item.value {
                    queryParams[item.name] = value
                }
            }
            
            return queryParams
        }
    }
}
