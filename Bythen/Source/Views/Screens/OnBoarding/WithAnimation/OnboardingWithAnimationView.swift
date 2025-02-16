//
//  OnboardingWithAnimationView.swift
//  Bythen
//
//  Created by erlina ng on 04/11/24.
//
import SwiftUI

struct NewOnboarding1View: View {
    @State private var isSpinning = false
    @State private var onAppearImageAnimation = false
    @State private var onAppearSmallImageAnimation = false
    @State private var onAppearTextAnimation = false
    
    private let imageAnimation: Animation = Animation.easeIn(duration: 0.5).delay(0.2)
    private let smallImageAnimation: Animation = Animation.easeIn(duration: 0.5).delay(0.3)
    private let textAnimation: Animation = Animation.easeIn(duration: 0.5)

    var body: some View {
        VStack {
            Spacer()
            
            imageView
            
            Image(.onboarding1imageText)
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width - 140)
                .animation(textAnimation, value: onAppearTextAnimation)
                .onAppear {
                    onAppearTextAnimation = true
                }
                .offset(y: -50)
//                .offset(x: onAppearTextAnimation ? 0 : 100 , y: -50)
            Spacer()
            Spacer()
        }
    }
    
    var imageView: some View {
        ZStack {
            HStack {
                circulatAnimation
                Spacer()
            }
            .offset(x: 16, y: -130)
            ZStack {
                Image(.onboarding1imageCharacter)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width - 82)
                    .animation(imageAnimation, value: onAppearImageAnimation)
                    .onAppear { onAppearImageAnimation = true }
                    .offset(y: 20)
//                    .offset(x: onAppearImageAnimation ? 0 : 150, y: 20)
                
                Image(.onboarding1imageBg)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width - 82)
                    .animation(smallImageAnimation, value: onAppearSmallImageAnimation)
                    .onAppear { onAppearSmallImageAnimation = true }
                    .offset(y: -30)
//                    .offset(x: onAppearSmallImageAnimation ? 20 : 170, y: -30)
            }
        }
    }
    
    var circulatAnimation: some View {
        ZStack {
            Image("circle-ring")
                .rotationEffect(.degrees(isSpinning ? 360 : 0))
                .animation(.linear(duration: 5).repeatForever(autoreverses: false), value: isSpinning)
                .onAppear { isSpinning.toggle() }
                .frame(width: 107, height: 107)
        }
    }
}

struct AnimationOnboardingView: View {
    @State private var onAppearCharacterImageAnimation = false
    @State private var onAppearDecorationImageAnimation = false
    @State private var onAppearTextAnimation = false
    
    private let characterImageAnimation: Animation = Animation.easeIn(duration: 0.6).delay(0.5)
    private let decorationImageAnimation: Animation = Animation.easeIn(duration: 0.6).delay(0.6)
    private let textAnimation: Animation = Animation.easeIn(duration: 0.5).delay(0.3)
    
    private let textImage: String
    private let decorationImages: String
    private let charactherImage: String
    
    internal init( textImage: String, decorationImages: String, charactherImage: String) {
        self.textImage = textImage
        self.decorationImages = decorationImages
        self.charactherImage = charactherImage
    }
    
    var body: some View {
        ZStack {
            Image(textImage)
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width)
                .animation(textAnimation, value: onAppearTextAnimation)
                .onAppear { onAppearTextAnimation = true }
//                .offset(x: onAppearTextAnimation ? 0 : 150)
            
            Image(charactherImage)
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width)
                .animation(characterImageAnimation, value: onAppearCharacterImageAnimation)
                .onAppear { onAppearCharacterImageAnimation = true }
//                .offset(x: onAppearCharacterImageAnimation ? 0 : 150)
            
            Image(decorationImages)
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width)
                .animation(decorationImageAnimation, value: onAppearDecorationImageAnimation)
                .onAppear { onAppearDecorationImageAnimation = true }
//                .offset(x: onAppearDecorationImageAnimation ? 0 : 150)
        }
        .ignoresSafeArea()
    }
}
