//
//  GifImageView.swift
//  Bythen
//
//  Created by edisurata on 25/10/24.
//

import SwiftUI
import UIKit

extension UIImage {
    static func animatedImage(withGIFData data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
 
        let frameCount = CGImageSourceGetCount(source)
        var frames: [UIImage] = []
        var gifDuration = 0.0
 
        for i in 0..<frameCount {
            guard let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) else { continue }
 
            if let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil), let gifInfo = (properties as NSDictionary)[kCGImagePropertyGIFDictionary as String] as? NSDictionary, let frameDuration = (gifInfo[kCGImagePropertyGIFDelayTime as String] as? NSNumber)
            {
                gifDuration += frameDuration.doubleValue
            }
 
            let frameImage = UIImage(cgImage: cgImage)
            frames.append(frameImage)
        }
 
        let animatedImage = UIImage.animatedImage(with: frames, duration: gifDuration)
        return animatedImage
    }
}

struct GIFImageView: UIViewRepresentable {
    let gifName: String

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
        if let path = Bundle.main.path(forResource: gifName, ofType: "gif"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
           let gifImage = UIImage.animatedImage(withGIFData: data) {
            uiView.image = gifImage
        }
    }
}

#Preview {
    GIFImageView(gifName: "PP")
}
