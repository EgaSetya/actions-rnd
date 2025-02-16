//
//  CustomVideoPlayer.swift
//  Bythen
//
//  Created by Ega Setya on 07/01/25.
//

import AVKit
import SwiftUI

struct CustomVideoPlayer: View {
    @ObservedObject private var videoPlayerManager: VideoPlayerManager
    @State private var isShowVideoPlayerThumbnail: Bool = true
    
    private var videoPlayerThumbnail: some View {
        Group {
            Image("hive-greeting-video-thumbnail")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
            
            Image(systemName: "play.fill")
                .frame(width: 15, height: 19)
                .padding(16)
                .foregroundColor(.byteBlack)
                .background(
                    Circle().fill(.gokuOrange300)
                )
                .overlay {
                    Circle().stroke(.appBlack, lineWidth: 1)
                }
        }
        .isHidden(!isShowVideoPlayerThumbnail)
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.25), value: isShowVideoPlayerThumbnail)
        .onTapGesture {
            isShowVideoPlayerThumbnail.toggle()
            play()
        }
    }

    init(url: URL?) {
        self.videoPlayerManager = VideoPlayerManager(url: url)
    }

    var body: some View {
        VideoPlayer(player: videoPlayerManager.avPlayer)
            .overlay {
                videoPlayerThumbnail
            }
            .onChange(of: videoPlayerManager.url) { newURL in
                videoPlayerManager.updateURL(newURL)
            }
    }

    // External control methods
    func play() {
        videoPlayerManager.play()
    }

    func pause() {
        videoPlayerManager.pause()
    }

    func stop() {
        videoPlayerManager.stop()
    }
}

class VideoPlayerManager: ObservableObject {
    var avPlayer: AVPlayer?
    var url: URL?

    init(url: URL?) {
        self.url = url
        if let url {
            self.avPlayer = AVPlayer(url: url)
        }
    }

    func updateURL(_ url: URL?) {
        guard let videoURL = url else { return }
        avPlayer?.replaceCurrentItem(with: AVPlayerItem(url: videoURL))
    }

    func play() {
        avPlayer?.play()
    }

    func pause() {
        avPlayer?.pause()
    }

    func stop() {
        avPlayer?.pause()
        avPlayer?.seek(to: .zero)
    }
}
