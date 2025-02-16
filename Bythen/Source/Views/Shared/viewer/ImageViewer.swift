//
//  ImageViewer.swift
//  Bythen
//
//  Created by Darindra R on 11/10/24.
//

import Combine
import SwiftUI

public struct ImageViewer: View {
    let image: Image

    @Environment(\.dismiss)
    private var dismiss

    @State private var shouldShowCloseButton: Bool = true
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 1

    @State private var offset: CGPoint = .zero
    @State private var lastTranslation: CGSize = .zero

    @State private var cancellable: AnyCancellable?

    public init(image: Image) {
        self.image = image
    }

    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.black
                    .edgesIgnoringSafeArea(.all)

                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .offset(x: offset.x, y: offset.y)
                    .gesture(makeDragGesture(size: proxy.size))
                    .gesture(makeMagnificationGesture(size: proxy.size))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                toggleCloseButton()
            }
            .overlay(alignment: .top) {
                if shouldShowCloseButton {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.headline)
                        }
                        .buttonStyle(.bordered)
                        .clipShape(Circle())
                        .tint(.white)
                        .padding(.all, 16)

                        Spacer()
                    }
                    .background(.appBlack.opacity(0.75))
                    .onAppear {
                        startCloseButtonAutoDismiss()
                    }
                }
            }
        }
    }

    private func toggleCloseButton() {
        shouldShowCloseButton.toggle()
        if shouldShowCloseButton {
            startCloseButtonAutoDismiss()
        } else {
            cancellable?.cancel()
        }
    }

    private func startCloseButtonAutoDismiss() {
        cancellable?.cancel()
        cancellable = Timer.publish(every: 3, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                withAnimation {
                    shouldShowCloseButton = false
                }
                cancellable?.cancel()
            }
    }

    private func makeMagnificationGesture(size: CGSize) -> some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let delta = value / lastScale
                lastScale = value

                // To minimize jittering
                if abs(1 - delta) > 0.01 {
                    scale *= delta
                }
            }
            .onEnded { _ in
                lastScale = 1
                if scale < 1 {
                    withAnimation {
                        scale = 1
                    }
                }
                adjustMaxOffset(size: size)
            }
    }

    private func makeDragGesture(size: CGSize) -> some Gesture {
        DragGesture()
            .onChanged { value in
                let diff = CGPoint(
                    x: value.translation.width - lastTranslation.width,
                    y: value.translation.height - lastTranslation.height
                )
                offset = .init(x: offset.x + diff.x, y: offset.y + diff.y)
                lastTranslation = value.translation
            }
            .onEnded { _ in
                adjustMaxOffset(size: size)
            }
    }

    private func adjustMaxOffset(size: CGSize) {
        let maxOffsetX = (size.width * (scale - 1)) / 2
        let maxOffsetY = (size.height * (scale - 1)) / 2

        var newOffsetX = offset.x
        var newOffsetY = offset.y

        if abs(newOffsetX) > maxOffsetX {
            newOffsetX = maxOffsetX * (abs(newOffsetX) / newOffsetX)
        }
        if abs(newOffsetY) > maxOffsetY {
            newOffsetY = maxOffsetY * (abs(newOffsetY) / newOffsetY)
        }

        let newOffset = CGPoint(x: newOffsetX, y: newOffsetY)
        if newOffset != offset {
            withAnimation {
                offset = newOffset
            }
        }
        lastTranslation = .zero
    }
}
