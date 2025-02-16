//
//  OnboardingChatView.swift
//  Bythen
//
//  Created by edisurata on 09/09/24.
//

import SwiftUI
import FirebaseAnalytics

struct GenderChipView: View {
    var title: String
    var value: ByteGender
    @Binding var gender: ByteGender
    var actionHandler: () -> Void = {}
    var selectedBgColor: Color = .white

    var body: some View {
        Button(action: {
            gender = value
            actionHandler()
        }) {
            Text(title)
                .foregroundStyle(.appBlack)
                .frame(maxWidth: .infinity, maxHeight: 36)
                .padding([.leading, .trailing], 10)
                .font(FontStyle.foundersGrotesk(.semibold, size: 14))
        }
        .frame(maxHeight: 36)
        .overlay(
            RoundedRectangle(cornerRadius: 19)
                .stroke(isSelected() ? .appBlack : .appBlack.opacity(0.7), lineWidth: isSelected() ? 2 : 1)
        )
        .background(isSelected() ? selectedBgColor : .clear)
        .clipShape(RoundedRectangle(cornerRadius: 19))
    }

    private func isSelected() -> Bool {
        return gender == value
    }
}

struct OnboardingChatView: View {
    @EnvironmentObject var mainState: MainViewModel
    @StateObject var viewModel: OnboardingChatViewModel
    @State private var subviewFrame: CGRect = .zero
    @State private var isShowAgeTooltip: Bool = false
    @State var isEditing: Bool = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    HStack {
                        SideMenuButton()
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .colorScheme(.light)
                        Spacer()
                    }
                    ZStack {
                        Rectangle()
                            .frame(width: 140, height: 140)
                            .padding([.leading, .top], 10)

                        CachedAsyncImage(urlString: viewModel.byteImageUrl)
                            .frame(width: 140, height: 140)
                            .border(.appBlack, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                            .background(.white)
                        
                        if viewModel.isEnableFloatAnimation {
                            ForEach(Array(viewModel.stickers.enumerated()), id: \.element.id) { idx, sticker in
                                CachedAsyncImage(
                                    urlString: sticker.imageUrl,
                                    onSuccess: {
                                        withAnimation {
                                            viewModel.stickers[idx].isAnimated.toggle()
                                        }
                                    }
                                )
                                .frame(maxWidth: 50, maxHeight: 50)
                                .padding(.leading, sticker.leading)
                                .padding(.top, sticker.top)
                                .padding(.trailing, sticker.trailing)
                                .padding(.bottom, sticker.bottom)
                                .offset(
                                    y: sticker.isAnimated ? 0 : viewModel.stickerAnimation.offset)
                                .animation(
                                    Animation.easeInOut(
                                        duration: viewModel.stickerAnimation.duration
                                    )
                                    .repeatForever(autoreverses: true),
                                    value: sticker.isAnimated
                                )
                            }
                        }
                    }

                    Text("Before you meet your new Byte, tell us a bit about them.")
                        .font(FontStyle.foundersGrotesk(.medium, size: 28))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("BYTE'S NAME")
                        .font(FontStyle.dmMono(.medium, size: 11))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .padding(.bottom, 0)

                    VStack(spacing: 0) {
                        TextField("ENTER NAME", text: $viewModel.byteName)
                            .font(FontStyle.foundersGrotesk(.medium, size: 32))
                            .padding()
                            .padding(.top, -20)
                            .disableAutocorrection(true)
                            .onChange(of: viewModel.byteName) { newText in
                                var newByteName = newText

                                newByteName = newByteName.filter { "_-.0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".contains($0) }

                                if newByteName.count > 15 {
                                    newByteName = String(newByteName.prefix(15))
                                }

                                viewModel.byteName = newByteName
                            }
                            .keyboardType(.asciiCapable)
                        Rectangle()
                            .fill(.appBlack.opacity(0.3))
                            .frame(height: 1)
                            .padding()
                            .padding(.top, -25)

                        if !viewModel.byteName.isEmpty {
                            Text("\(viewModel.byteName.count)/15 Character")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(FontStyle.neueMontreal(size: 12))
                                .foregroundStyle(.appBlack.opacity(0.5))
                                .padding()
                                .padding(.top, -25)
                        }

                        HStack(spacing: 0) {
                            VStack {
                                HStack(spacing: 0) {
                                    Text("AGE")
                                        .font(FontStyle.dmMono(.medium, size: 11))
                                    Image("info")
                                        .resizable()
                                        .frame(width: 12, height: 12)
                                        .onTapGesture {
                                            isShowAgeTooltip.toggle()
                                        }
                                        .padding(.leading, 4)
                                }
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .padding(.bottom, 0)
                                TextField("YY", text: $viewModel.byteAge)
                                    .frame(maxWidth: 60)
                                    .font(FontStyle.foundersGrotesk(.semibold, size: 32))
                                    .padding(.top, -10)
                                    .keyboardType(.numberPad)
                                    .onChange(of: viewModel.byteAge) { newValue in
                                        var newByteAge = newValue
                                        newByteAge = newByteAge.filter { "0123456789".contains($0) }
                                        if newByteAge.count > 2 {
                                            newByteAge = String(newByteAge.prefix(2))
                                        }

                                        viewModel.byteAge = newByteAge
                                    }

                                Rectangle()
                                    .fill(.appBlack.opacity(0.3))
                                    .frame(height: 1)
                                    .padding(.top, -5)
                            }
                            .frame(maxWidth: 60, maxHeight: 80, alignment: .topLeading)
                            .padding([.leading, .top, .bottom, .trailing])

                            VStack {
                                Text("GENDER")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(FontStyle.dmMono(.medium, size: 11))
                                    .padding(.bottom, 0)
                                HStack {
                                    GenderChipView(title: "MALE", value: .male, gender: $viewModel.byteGender)
                                        .frame(maxWidth: 54)

                                    GenderChipView(title: "FEMALE", value: .female, gender: $viewModel.byteGender)
                                        .frame(maxWidth: 67)

//                                    GenderChipView(title: "NON-BINARY", value: .nonbinary, gender: $viewModel.byteGender)
//                                        .frame(maxWidth: 92)

                                    Spacer()
                                }
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .padding([.top, .bottom, .trailing])
                        }
                        .frame(maxWidth: .infinity, alignment: .topLeading)

                        BasicSquareButton(
                            title: "Save Profile",
                            background: .appBlack,
                            foregroundColor: .white,
                            isEnableTint: true,
                            rightIconName: "arrow-white") {
                                viewModel.createBuild()
                            }
                            .padding()
                            .environment(\.isEnabled, viewModel.isSaveButtonValid)

                        Text("You can always change your Byte's profile in Dojo if you change your mind.")
                            .font(FontStyle.neueMontreal(size: 12))
                            .foregroundStyle(.appBlack.opacity(0.5))
                            .padding()
                            .multilineTextAlignment(.center)
                    }
                    .overlay {
                        if isShowAgeTooltip {
                            Tooltip(content: "Age will impact your Byte’s dialogue style  in a way that corresponds to human development stages.")
                                .frame(width: 260, height: 80)
                                .offset(x: -10, y: -65)
                        }
                    }
                }

                Spacer()
            }
            
            if isEditing {
                Color.white.opacity(0.1)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onTapGesture {
                        if isEditing {
                            hideKeyboard()
                        }
                    }
            }
            
            if isShowAgeTooltip {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isShowAgeTooltip = false
                    }
            }
        }
        .background(.appCream)
        .onAppear(perform: {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { _ in
                isEditing = true
            }
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                isEditing = false
            }
            
            viewModel.setMainState(state: mainState)
            viewModel.fetchData()
        })
        .trackView(page: "onboarding_chat", className: "OnboardingChatView")
    }
}

#Preview {
    var vm: OnboardingChatViewModel = OnboardingChatViewModel.new(
        byteBuild: ByteBuild()
    )
    
    return OnboardingChatView(viewModel: vm)
        .environmentObject(MainViewModel.new())
}
