//
//  ByteBottomSheet.swift
//  Bythen
//
//  Created by erlina ng on 03/10/24.
//

import SwiftUI

struct ByteBottomSheet<Content: View>: View {
    // MARK: -  Properties 💡
    @State internal var isShowBottomSheet: Bool = true
    private let onDismiss: (Bool) -> Void
    
    // MARK: -  UI Components 🎨
    private let content: Content
    private let backgroundColor: Color
    private let spacing: CGFloat

    init(
        onDismiss: @escaping (Bool) -> Void,
        @ViewBuilder content: () -> Content,
        backgroundColor: Color,
        spacing: CGFloat
    ) {
        self.content = content()
        self.backgroundColor = backgroundColor
        self.spacing = spacing
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        if isShowBottomSheet {
            ZStack(alignment: .bottom) {
                Color.appBlack.opacity(0.7)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        dismissBottomsheet()
                    }
                VStack(spacing: spacing) {
                    HStack {
                        Image("close")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(.byteBlack)
                            .frame(width: 13.5, height: 13.5)
                            .onTapGesture {
                                dismissBottomsheet()
                            }
                        Spacer()
                    }
                    .padding([.horizontal, .top], 16)
                    
                    content
                        .padding(.bottom, 42)
                }
                .transition(.move(edge: .bottom))
                .animation(.easeInOut, value: isShowBottomSheet)
                .background(backgroundColor)
                .cornerRadius(8, corners: [.topLeft, .topRight])
            }
            .ignoresSafeArea()
        }
    }
    
    private func dismissBottomsheet() {
        isShowBottomSheet = false
        onDismiss(isShowBottomSheet)
    }
}
