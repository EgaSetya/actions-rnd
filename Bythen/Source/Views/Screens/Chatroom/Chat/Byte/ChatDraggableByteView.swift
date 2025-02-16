//
//  ChatDraggableByteView.swift
//  Bythen
//
//  Created by Darindra R on 22/09/24.
//

import SwiftUI

struct ChatDraggableByteView: View {
    enum Position {
        case top
        case bottom
    }

    @Binding var maxTopBoundary: CGFloat
    @Binding var maxBottomBoundary: CGFloat
    @Binding private var offset: CGSize

    @State private var position: ChatDraggableByteView.Position
    @State private var dragOffset: CGSize = .zero
    @State private var isOnDrag: Bool = false

    init(maxTopBoundary: Binding<CGFloat>, maxBottomBoundary: Binding<CGFloat>, offset: Binding<CGSize>) {
        _maxTopBoundary = maxTopBoundary
        _maxBottomBoundary = maxBottomBoundary
        _offset = offset
        _position = State(initialValue: offset.height.wrappedValue == maxTopBoundary.wrappedValue ? .top : .bottom)
    }

    var body: some View {
        UnityView()
            .frame(width: 120, height: 160)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .offset(
                x: offset.width + dragOffset.width,
                y: offset.height + dragOffset.height
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation
                    }
                    .onEnded { _ in
                        let previousX = offset.width
                        let previousY = offset.height

                        offset.width += dragOffset.width
                        offset.height += dragOffset.height

                        withAnimation(.linear(duration: 0.15)) {
                            /// Snap to left or right based on user drag direction
                            if dragOffset.width < -32 {
                                offset.width = 16
                            } else if dragOffset.width > 32 {
                                offset.width = UIScreen.main.bounds.width - 136 /// Byte width + right margin
                            } else {
                                offset.width = previousX
                            }

                            /// Snap to top or bottom based on user drag direction
                            if dragOffset.height < -32 {
                                position = .top
                                offset.height = maxTopBoundary
                            } else if dragOffset.height > 32 {
                                position = .bottom
                                offset.height = maxBottomBoundary - 160 /// Byte height
                            } else {
                                offset.height = previousY
                            }
                        }

                        /// Reset the dragOffset after the gesture ends, so it doesn't interfere with future drags
                        dragOffset = .zero
                    }
            )
            .onChange(of: maxBottomBoundary) { _ in
                if position == .bottom {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        offset.height = maxBottomBoundary - 160
                    }
                }
            }
    }
}
