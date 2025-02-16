//
//  ChangeBackgroundView.swift
//  Bythen
//
//  Created by edisurata on 24/09/24.
//

import SwiftUI

struct ChangeBackgroundView: View {
    @EnvironmentObject var mainState: MainViewModel
    @Environment(\.colorScheme) var theme
    
    @Binding var isPresent: Bool
    @State private var selectedColor = Color.blue
    @State var isBgImage = true
    @State var showExceedFileLimit: Bool = false
    
    @StateObject var viewModel: ChangeBackgroundVM
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("BACKGROUND")
                            .frame(maxWidth: .infinity, maxHeight: 24, alignment: .leading)
                            .font(FontStyle.foundersGrotesk(.semibold, size: 24))
                            .foregroundStyle(ByteColors.foreground(for: theme))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                        Button(action: {
                            withAnimation {
                                isPresent = false
                            }
                            
                        }, label: {
                            Image("close")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundStyle(ByteColors.foreground(for: theme))
                                .frame(width: 12, height: 12)
                                .padding(10)
                        })
                        .padding(16)
                    }
                    HStack {
                        Button(action: {
                            isBgImage = true
                        }, label: {
                            Image("change-bg")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 24, height: 24)
                                .foregroundStyle(isBgImage ? ByteColors.foreground(for: theme) : ByteColors.foreground(for: theme).opacity(0.7))
                            
                            Text("IMAGE")
                                .font(FontStyle.foundersGrotesk(.semibold, size: 14))
                                .foregroundStyle(isBgImage ? ByteColors.foreground(for: theme) : ByteColors.foreground(for: theme).opacity(0.7))
                        })
                        .padding(.leading, 16)
                        .padding(.vertical, 12)
                        
                        Button(action: {
                            isBgImage = false
                        }, label: {
                            Image("change-color")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 24, height: 24)
                                .foregroundStyle(isBgImage ? ByteColors.foreground(for: theme) : ByteColors.foreground(for: theme).opacity(0.7))
                            
                            Text("COLOR")
                                .font(FontStyle.foundersGrotesk(.semibold, size: 14))
                                .foregroundStyle(isBgImage ? ByteColors.foreground(for: theme) : ByteColors.foreground(for: theme).opacity(0.7))
                        })
                        .padding(.leading, 24)
                        .padding(.vertical, 12)
                        
                        Spacer()
                        
                        if isBgImage {
                            Button {
                                viewModel.isSelectingImageForUpload = true
                                
                            } label: {
                                Image("select-bg-photo")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(ByteColors.foreground(for: theme))
                                
                                Text("UPLOAD")
                                    .font(FontStyle.foundersGrotesk(.semibold, size: 14))
                                    .foregroundStyle(ByteColors.foreground(for: theme))
                            }
                            .padding(.trailing, 16)
                        }
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 12)
                    
                    Color.appBlack.opacity(0.1).frame(maxWidth: .infinity, maxHeight: 2)
                    if isBgImage {
                        Text("Preset Background")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(FontStyle.neueMontreal(.medium, size: 16))
                            .foregroundStyle(ByteColors.foreground(for: theme))
                            .padding(.top, 16)
                            .padding(.horizontal, 16)
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 8) {
                                ForEach(viewModel.bgImagePresets, id: \.id) { bgImage in
                                    
                                    Button(action: {
                                        viewModel.changeBgImage(imageUrl: bgImage.background)
                                    }) {
                                        CachedAsyncImage(urlString: bgImage.background)
                                            .frame(width: 48, height: 48)
                                            .clipped()
                                            .background(
                                                viewModel.selectedImageUrl == bgImage.background ? Rectangle().stroke(.gokuOrange400, lineWidth: 3) : nil
                                            )
                                            .padding(.vertical, 8)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 16)
                        }
                        
                        Text("Uploaded Background (\(viewModel.bgImages.count))/5")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(FontStyle.neueMontreal(.medium, size: 16))
                            .foregroundStyle(ByteColors.foreground(for: theme))
                            .padding(.top, 16)
                            .padding(.horizontal, 16)
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 8) {
                                if viewModel.bgImages.isEmpty {
                                    Button(action: {
                                        viewModel.isSelectingImageForUpload = true
                                    }) {
                                        Image("select-bg-photo")
                                            .resizable()
                                            .renderingMode(.template)
                                            .foregroundStyle(ByteColors.foreground(for: theme))
                                            .frame(width: 16, height: 16)
                                            .padding(16)
                                    }
                                }
                                ForEach(viewModel.bgImages, id: \.id) { bgImage in
                                    Button(action: {
                                        viewModel.changeBgImage(imageUrl: bgImage.imageUrl)
                                    }) {
                                        CachedAsyncImage(urlString: bgImage.imageUrl)
                                            .frame(width: 48, height: 48)
                                            .clipped()
                                            .background(
                                                viewModel.selectedImageUrl == bgImage.imageUrl ? Rectangle().stroke(.gokuOrange400, lineWidth: 3) : nil
                                            )
                                            .padding(.vertical, 8)
                                    }
                                    .contextMenu(ContextMenu(menuItems: {
                                        Button(role: .destructive, action: {
                                            viewModel.deletedBgImages = bgImage
                                            viewModel.isShowDeleteDialog = true
                                        }, label: {
                                            Label("Delete", image: "delete")
                                        })
                                    }))
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 16)
                        }
                        
                    } else {
                        Text("Preset Color")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(FontStyle.neueMontreal(.medium, size: 16))
                            .padding(.top, 16)
                            .padding(.horizontal, 16)
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                ZStack {
                                    Image("color-picker")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .disabled(true)
                                    ColorPicker("", selection: $selectedColor)
                                        .opacity(0.1)
                                        .labelsHidden()
                                        .onChange(of: selectedColor) { color in
                                            Logger.logInfo(color)
                                            viewModel.delayedAction(after: 1) {
                                                viewModel.changeBgColor(color: selectedColor.toHexString())
                                            }
                                        }
                                    
                                }
                                ForEach(viewModel.colorPresets, id: \.id) { bgColor in
                                    Button {
                                        viewModel.changeBgColor(color: bgColor.background)
                                    } label: {
                                        Circle()
                                            .fill(viewModel.selectedColor == bgColor.background ? .white : Color(hex: bgColor.background))
                                            .frame(width: 35, height: 35)
                                            .overlay(
                                                Circle()
                                                    .fill(Color(hex: bgColor.background))
                                                    .frame(width: 30, height: 30)
                                            )
                                            .background(
                                                Circle()
                                                    .fill(Color(hex: bgColor.background))
                                                    .frame(width: 40, height: 40)
                                            )
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 16)
                        }
                        
                        Text("Recently Use")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(FontStyle.neueMontreal(.medium, size: 16))
                            .padding(.top, 16)
                            .padding(.horizontal, 16)
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                ForEach(viewModel.colors, id: \.colorID) { bgColor in
                                    Button {
                                        viewModel.changeBgColor(color: bgColor.color)
                                    } label: {
                                        Circle()
                                            .fill(viewModel.selectedColor == bgColor.color ? .white : Color(hex: bgColor.color))
                                            .frame(width: 35, height: 35)
                                            .overlay(
                                                Circle()
                                                    .fill(Color(hex: bgColor.color))
                                                    .frame(width: 30, height: 30)
                                            )
                                            .background(
                                                Circle()
                                                    .fill(Color(hex: bgColor.color))
                                                    .frame(width: 40, height: 40)
                                            )
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 16)
                        }
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: 326)
                .background(ByteColors.background(for: theme))
                .onChange(of: selectedColor) { newColor in
                    
                }
            }
            .onAppear(perform: {
                self.viewModel.setMainState(state: mainState)
                self.viewModel.fetchData()
            })
            
            if viewModel.isShowDeleteDialog {
                AlertView(
                    didDismiss: {
                        viewModel.isShowDeleteDialog = false
                    },
                    title: "Delete Background",
                    content: "Are you sure you want to delete this background",
                    imageName: "priority-high",
                    actionType: .normal,
                    actionTitle: "YES, DELETE",
                    action: {
                        viewModel.deleteBackgroundImage()
                    },
                    isHasCancel: true,
                    cancelTitle: "NO, KEEP IT"
                )
            }
        }
        .overlay(alignment: .center, content: {
            if showExceedFileLimit {
                AlertView(
                    didDismiss: {
                        showExceedFileLimit.toggle()
                    },
                    title: "Exceed File Limit",
                    content: "You've exceeded the file limit of 8MB. Please reduce your file size and try again.",
                    imageName: "priority-high",
                    actionTitle: "OK",
                    action: {
                        showExceedFileLimit.toggle()
                    }
                )
            }
        })
        .sheet(isPresented: $viewModel.isSelectingImageForUpload) {
            ImagePicker(
                didFinishPicking: { image in
                    viewModel.uploadBgImage(image: image)
                },
                didFailedValidation: {
                    showExceedFileLimit = true
                }
            )
            .ignoresSafeArea(.all)
        }
    }
}

#Preview {
    VStack {
        ChangeBackgroundView(isPresent: .constant(true), viewModel: ChangeBackgroundVM.new(byteID: 57, byteSymbol: "bytes", originSymbol: "azk", background: "#000000", backgroundType: .color))
            .environmentObject(MainViewModel.new())
            .colorScheme(.dark)
    }
}
