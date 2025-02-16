//
//  RemoteImage.swift
//  Bythen
//
//  Created by Ega Setya on 16/12/24.
//

import SwiftUI
import Alamofire
import AlamofireImage

struct RemoteImage: View {
    @Binding var urlString: String
    @Binding var isLoading: Bool
    
    var placeholderImage: String?
    var delay: Double = 0.0
    
    @State private var uiImage: UIImage?
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            
            ZStack {
                NetworkProgressView(size: width / 2.5, lineWidth: 4)
                    .background(Color.gray.opacity(0.2))
                    .opacity(isLoading ? 1 : 0)
                    .zIndex(1)
                
                Group {
                    if let image = uiImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                    } else if let placeholderImage = placeholderImage {
                        Image(placeholderImage)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Text("Failed to load image")
                    }
                }
            }
            .frame(width: width, height: width, alignment: .center)
            .clipped()
            .onAppear {
                loadImage()
            }
            .onChange(of: urlString) { _ in
                loadImage()
            }
        }
    }
    
    private func loadImage() {
        isLoading = true
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            loadPlaceholderImage()
            return
        }
        
        let downloader = ImageDownloader.default
        let urlRequest = URLRequest(url: url)
        
        downloader.download(urlRequest, completion:  { response in
            switch response.result {
            case .success(let image):
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    self.uiImage = image
                    self.isLoading = false
                }
            case .failure(let error):
                print("Image load error: \(error.localizedDescription)")
                loadPlaceholderImage()
            }
        })
    }
    
    private func loadPlaceholderImage() {
        if let placeholderImage = placeholderImage {
            uiImage = UIImage(named: placeholderImage)
        }
        isLoading = false
    }
}
