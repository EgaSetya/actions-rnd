//
//  StudioSavedView.swift
//  Bythen
//
//  Created by edisurata on 14/11/24.
//

import SwiftUI
import AVKit
import Photos

struct StudioSavedView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var assetID: String
    @State var isLandscape: Bool = false
    @State private var videoURL: URL?
    @State private var isVideoLoaded = false
    @State private var showShareSheet = false
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Image("check")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.white)
                    .frame(width: 10, height: 10)
                    .padding(8)
                    .background(Circle().fill(.sonicBlue500))
                Text("Saved to your library")
                    .font(.neueMontreal(.medium, size: 18))
                    .foregroundStyle(.white)
            }
            .padding(.vertical, 16)
            
            if let url = videoURL {
                VideoPlayerView(url: url)
                    .frame(maxWidth: .infinity, maxHeight: isLandscape ? 270 : 450)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
            } else {
                Color.white.opacity(0.1)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .overlay {
                        NetworkProgressView()
                    }
            }
            
            Button(action: {
                showShareSheet = true
            }, label: {
                HStack {
                    Image("share-nodes.sharp.regular")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.white)
                        .frame(width: 20, height: 20)
                        .padding(.leading, 16)
                    Text("SHARE VIDEO")
                        .font(.foundersGrotesk(.semibold, size: 16))
                        .foregroundStyle(.white)
                        .padding(.vertical, 16)
                        .padding(.trailing, 24)
                }
                .frame(width: 202)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.white.opacity(0.1))
                )
            })
            .padding(.top, 32)
            
            Button {
                dismiss()
            } label: {
                HStack {
                    Image("film-slate")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.leading, 16)
                    Text("TAKE ANOTHER VIDEO")
                        .font(.foundersGrotesk(.semibold, size: 16))
                        .foregroundStyle(.white)
                        .padding(.vertical, 14)
                        .padding(.trailing, 24)
                }
                .frame(width: 202)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(.white, lineWidth: 1)
                )
            }
            .padding(.top, 16)
            .padding(.bottom, 38)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.byteBlack)
        .onAppear {
            loadVideo()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image("arrow-back")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.white)
                        .frame(width: 24, height: 24)
                        .padding(8)
                }
                
            }
            
            ToolbarItem(placement: .principal) {
                Text("Share Video")
                    .font(.neueMontreal(.medium, size: 18))
                    .foregroundStyle(.white)
            }
        }
        .sheet(isPresented: $showShareSheet) {
            if let videoURL = videoURL {
                ShareSheet(items: [videoURL])
            }
        }
    }
    
    func loadVideo() {
        getVideoURL(for: assetID) { url in
            DispatchQueue.main.async {
                self.videoURL = url
                self.isVideoLoaded = url != nil
            }
        }
    }
    
    func getVideoURL(for assetID: String, completion: @escaping (URL?) -> Void) {
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [assetID], options: nil)
        guard let asset = assets.firstObject else {
            completion(nil)
            return
        }

        let options = PHVideoRequestOptions()
        options.deliveryMode = .highQualityFormat

        PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { avAsset, _, _ in
            if let urlAsset = avAsset as? AVURLAsset {
                completion(urlAsset.url)
            } else {
                completion(nil)
            }
        }
    }
}

#Preview {
    StudioSavedView(assetID: "")
}
