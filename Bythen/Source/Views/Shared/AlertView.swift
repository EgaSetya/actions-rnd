//
//  PopupView.swift
//  Bythen
//
//  Created by edisurata on 22/09/24.
//

import SwiftUI

struct AlertView: View {
    enum AlertViewAction {
        case cancel
        case delete
        case normal
    }
    
    var didDismiss: (() -> Void)
    var title: String
    var content: String = ""
    var imageName: String?
    var actionType: AlertViewAction = .normal
    var actionTitle: String = ""
    var action: () -> Void = {}
    var isHasCancel: Bool = false
    var cancelTitle: String = "Ok"
    var isEditMode: Bool = false
    var disableDismiss: Bool = false
    @State var editText: String = ""
    var editTextHanlder: (_ text: String) -> Void = {text in }
    @State private var optionalPaddingBottom: CGFloat = 0
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            Color.appBlack.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture(perform: {
                    if isFocused {
                        isFocused.toggle()
                    } else {
                        if disableDismiss {
                            return
                        }
                        didDismiss()
                    }
                })
            
            VStack {
                HStack {
                    if !disableDismiss {
                        Button(action: didDismiss, label: {
                            Image("close")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 16, height: 16)
                                .foregroundStyle(.byteBlack)
                                .padding(10)
                        })
                        .padding()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 52, alignment: .trailing)
                
                if let imageName {
                    Image(imageName)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(.appBlack)
                        .padding(12)
                        .background(
                            Circle()
                                .fill(.appBlack.opacity(0.1))
                        )
                        .padding(.bottom, 12)
                }
                
                Text(title)
                    .font(FontStyle.foundersGrotesk(.medium, size: 28))
                    .foregroundStyle(.byteBlack)
                    .padding(.bottom, 12)
                    .padding(.horizontal, 28)
                
                if content != "" {
                    Text(content)
                        .font(FontStyle.neueMontreal(size: 14))
                        .foregroundStyle(.byteBlack)
                        .lineSpacing(6)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 28)
                        .padding(.bottom, 28)
                }
                
                if isEditMode {
                    VStack {
                        TextField("Room Title", text: $editText)
                            .focused($isFocused)
                            .font(FontStyle.foundersGrotesk(size: 18))
                            .frame(maxWidth: .infinity, maxHeight: 26)
                        Rectangle()
                            .fill(.appBlack.opacity(0.3))
                            .frame(maxWidth: .infinity, maxHeight: 1)
                            .padding(.bottom)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 48)
                    .padding(.horizontal, 28)
                    .onKeyboardChange { keyboardHeight in
                        withAnimation {
                            optionalPaddingBottom = keyboardHeight / 2
                        }
                    }
                }
                
                VStack {
                Button(action: {
                    action()
                    editTextHanlder(editText)
                    didDismiss()
                }, label: {
                    Text(actionTitle)
                        .font(FontStyle.foundersGrotesk(.semibold, size: 20))
                        .frame(maxWidth: .infinity, maxHeight: 20)
                        .foregroundStyle(foregroundColor())
                        .padding(.vertical, 14)
                        .padding(.horizontal, 14)
                })
                .overlay(content: {
                    if actionType == .cancel {
                        Rectangle()
                            .stroke(foregroundColor(), lineWidth: 1)
                    }
                })
                .background(backgroundColor())
                .padding(.horizontal, 28)
                .padding(.bottom, 8)
                
                    if isHasCancel {
                        Button(action: didDismiss, label: {
                            Text(cancelTitle)
                                .font(FontStyle.foundersGrotesk(.semibold, size: 20))
                                .frame(maxWidth: .infinity, maxHeight: 20)
                                .foregroundStyle(.appBlack)
                                .padding(.vertical, 14)
                                .padding(.horizontal, 14)
                        })
                        .overlay(content: {
                            if actionType == .cancel {
                                Rectangle()
                                    .stroke(foregroundColor(), lineWidth: 1)
                            }
                        })
                        .background(.white)
                        .padding(.horizontal, 28)
                        .padding(.bottom, 8)
                    }
                }
                .padding(.bottom, 20)
            }
            .background(.white)
            .padding(.horizontal)
            .animation(.easeInOut(duration: 0.5), value: isFocused)
            .offset(y: -1 * optionalPaddingBottom)
        }
    }
    
    private func backgroundColor() -> Color {
        switch actionType {
        case .cancel:
            return .white
        case .delete:
            return .red
        default:
            return .appBlack
        }
    }
    
    private func foregroundColor() -> Color {
        switch actionType {
        case .cancel:
            return .appBlack
        case .delete:
            return .white
        default:
            return .white
        }
    }
}

#Preview {
    return VStack {
        AlertView(
            didDismiss: {
                
            },
            title: "This is Title",
            content: "This is loooooooonnnnngg content",
            actionType: .delete,
            actionTitle: "This is an action",
            action: {},
            isHasCancel: false,
            isEditMode: true,
            editText: "change this text",
            editTextHanlder: { text in
                
            }
        )
    }
}
