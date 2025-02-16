//
//  DialogView.swift
//  Bythen
//
//  Created by Ega Setya on 10/12/24.
//

import SwiftUI
import Combine

enum DialogType: Equatable {
    case error
    case success
    case warning
    case errorSubtle
}

struct DialogView: View {
    var type: DialogType = .success
    var text: String
    var showCloseButton: Bool = false
    @Binding var isPresented: Bool
    
    private var buttonView: some View {
        return Group {
            if showCloseButton {
                HStack {
                    Button(action: handleCloseTapped) {
                        Image("close")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 11, height: 11)
                            .foregroundStyle(configuration.textColor)
                            .padding(.trailing, 24)
                            .padding(.top, 24)
                    }
                }
            } else {
                EmptyView()
            }
        }
    }
    
    private var configuration: (iconName: String, backgroundColor: Color, textColor: Color, textSize: CGFloat) {
        switch type {
        case .error:
            return ("circle-exclamation-point", .elmoRed500, .white, 16.0)
        case .success:
            return ("circle-check", .yoshiGreen100, .byteBlack, 16.0)
        case .warning:
            return ("circle-exclamation-point", .flashYellow300, .byteBlack, 16.0)
        case .errorSubtle:
            return ("circle-exclamation-point", .elmoRed100, .byteBlack, 16.0)
        }
    }
    @State private var autoCloseTimer: Cancellable?
    
    private let autoClose: Bool = true
    private let autoCloseDuration: TimeInterval = 5.0
    
    var body: some View {
        let screenHeight = UIScreen.main.bounds.height
        let presentPosition = -screenHeight / 2.5
        
        HStack(spacing: 0) {
            Image(configuration.iconName)
                .resizable()
                .renderingMode(.template)
                .frame(width: 20, height: 20)
                .foregroundStyle(configuration.textColor)
                .padding(.leading, 16)
            Text(text)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(configuration.textColor)
                .font(FontStyle.neueMontreal(size: configuration.textSize))
                .lineSpacing(4)
                .padding(.vertical, 16)
                .padding(.horizontal, 16)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            buttonView
        }
        .background(configuration.backgroundColor)
        .cornerRadius(12, corners: .allCorners)
        .opacity(isPresented ? 1 : 0)
        .offset(y: isPresented ? presentPosition : -screenHeight)
        .animation(.easeOut(duration: 0.5), value: isPresented)
        .onChange(of: isPresented) { newValue in
            checkIsPresented(newValue)
        }
        .onDisappear {
            autoCloseTimer?.cancel()
        }
    }
    
    private func checkIsPresented(_ newValue: Bool) {
        if newValue == true && autoClose {
            autoCloseTimer?.cancel()
            
            autoCloseTimer = Just(())
                .delay(for: .seconds(autoCloseDuration), scheduler: DispatchQueue.main)
                .sink { _ in
                    if isPresented {
                        withAnimation {
                            isPresented = false
                        }
                    }
                }
        }
        
        if newValue == false {
            autoCloseTimer?.cancel()
        }
    }
    
    private func handleCloseTapped() {
        isPresented = false
    }
}
