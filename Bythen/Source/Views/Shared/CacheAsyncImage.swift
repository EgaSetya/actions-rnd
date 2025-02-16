//
//  CacheAsyncImage.swift
//  Bythen
//
//  Created by edisurata on 05/09/24.
//

import SwiftUI
import Alamofire
import AlamofireImage

struct CachedAsyncImage: View {
    var urlString: String
    var failureImage: String?
    var delay = 0.0
    var onSuccess: () -> Void = {}
    
    @State private var uiImage: UIImage?
    
    var body: some View {
        if let image = uiImage {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            ProgressView()
                .onAppear {
                    loadImage()
                }
        }
    }
    
    private func loadImage() {
        guard let url = URL(string: urlString) else {
            loadFailureImage()
            return
        }
        let downloader = ImageDownloader.default
        let urlRequest = URLRequest(url: url)
        
        // Load image from the cache or download it
        downloader.download(urlRequest, completion:  { response in
            if case .success(let image) = response.result {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    self.uiImage = image
                }
                onSuccess()
            }
        })
    }
    
    private func loadFailureImage() {
        if let image = failureImage {
            self.uiImage = UIImage(named: image)
        }
    }
}
