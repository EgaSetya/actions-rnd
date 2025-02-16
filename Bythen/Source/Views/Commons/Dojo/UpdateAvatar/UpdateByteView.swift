//
//  UpdateAvatarView.swift
//  Bythen
//
//  Created by edisurata on 04/10/24.
//

import SwiftUI
import FirebaseAnalytics

struct UpdateByteView: View {
    @EnvironmentObject var mainState: MainViewModel
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: UpdateByteViewModel
    @State var isEditing: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack {
                        Text("Byte's name")
                            .font(FontStyle.dmMono(.medium, size: 16))
                            .foregroundStyle(.appBlack)
                            .padding(.top, 36)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("", text: $viewModel.byteName)
                            .textFieldStyle(.plain)
                            .autocorrectionDisabled(true)
                            .accentColor(.appBlack)
                            .font(FontStyle.neueMontreal(.regular, size: 16))
                            .frame(height: 48)
                            .padding(.horizontal, 16)
                            .background(
                                Rectangle()
                                    .stroke(lineWidth: 1)
                                    .foregroundStyle(.appBlack.opacity(0.3))
                            )
                            .padding(.horizontal, 16)
                            .onChange(of: viewModel.byteName) { newText in
                                var newByteName = newText

                                newByteName = newByteName.filter { "-_.0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".contains($0) }

                                if newByteName.count > 15 {
                                    newByteName = String(newByteName.prefix(15))
                                }

                                viewModel.byteName = newByteName
                            }
                        if viewModel.byteName.count > 0 {
                            Text("\(viewModel.byteName.count)/15 Characters")
                                .font(FontStyle.neueMontreal(size: 12))
                                .foregroundStyle(.appBlack.opacity(0.5))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 16)
                                .padding(.top, 3)
                        }
                        
                        
                        Text("Age")
                            .font(FontStyle.dmMono(.medium, size: 16))
                            .foregroundStyle(.appBlack)
                            .padding(.top, 31)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .onChange(of: viewModel.byteAge) { newValue in
                                var newByteAge = newValue
                                newByteAge = newByteAge.filter { "0123456789".contains($0) }
                                if newByteAge.count > 2 {
                                    newByteAge = String(newByteAge.prefix(2))
                                }

                                viewModel.byteAge = newByteAge
                            }
                        HStack {
                            TextField("", text: $viewModel.byteAge)
                                .textFieldStyle(.plain)
                                .keyboardType(.numberPad)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                                .accentColor(.appBlack)
                                .font(FontStyle.neueMontreal(.regular, size: 16))
                                .frame(height: 48)
                                .padding(.horizontal, 16)
                            
                            Text("Y")
                                .font(FontStyle.neueMontreal(.regular, size: 16))
                                .padding()
                        }
                        .background(
                            Rectangle()
                                .stroke(lineWidth: 1)
                                .foregroundStyle(.appBlack.opacity(0.3))
                        )
                        .padding(.horizontal, 16)
                        
                        Text("Gender")
                            .font(FontStyle.dmMono(.medium, size: 16))
                            .foregroundStyle(.appBlack)
                            .padding(.top, 31)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            GenderChipView(title: "MALE", value: .male, gender: $viewModel.byteGender, selectedBgColor: .gokuOrange300)
                                .frame(maxWidth: 54)
                            
                            GenderChipView(title: "FEMALE", value: .female, gender: $viewModel.byteGender, selectedBgColor: .gokuOrange300)
                                .frame(maxWidth: 67)
                            
//                            GenderChipView(title: "NON-BINARY", value: .nonbinary, gender: $viewModel.byteGender, selectedBgColor: .gokuOrange300)
//                                .frame(maxWidth: 92)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 36)
                        .padding(.horizontal, 16)
                        
                        Text("Role")
                            .font(FontStyle.dmMono(.medium, size: 16))
                            .foregroundStyle(.appBlack)
                            .padding(.top, 31)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("", text: $viewModel.byteRole)
                            .textFieldStyle(.plain)
                            .autocorrectionDisabled(true)
                            .autocapitalization(.none)
                            .accentColor(.appBlack)
                            .font(FontStyle.neueMontreal(.regular, size: 16))
                            .frame(height: 48)
                            .padding(.horizontal, 16)
                            .background(
                                Rectangle()
                                    .stroke(lineWidth: 1)
                                    .foregroundStyle(.appBlack.opacity(0.3))
                            )
                            .padding(.horizontal, 16)
                            .onChange(of: viewModel.byteRole) { newText in
                                var newByteRole = newText

                                newByteRole = newByteRole.filter { "-_.0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ".contains($0) }

                                if newByteRole.count > 50 {
                                    newByteRole = String(newByteRole.prefix(50))
                                }

                                viewModel.byteRole = newByteRole
                            }
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .onAppear {
                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { _ in
                            isEditing = true
                        }
                        
                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                            isEditing = false
                        }
                        viewModel.setMainState(state: mainState)
                        viewModel.validatingSubmitButton()
                    }
                    .trackView(page: "update_byte", className: "UpdateByteView")
                    .onDisappear {
                        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
                        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                dismiss()
                            } label: {
                                Image("nav-back")
                                    .resizable()
                                    .tint(.appBlack)
                                    .frame(width: 24, height: 24)
                                    .padding(8)
                            }
                            
                        }
                        ToolbarItem(placement: .principal) { // Custom title placement
                            Text("BYTE PROFILE")
                                .font(FontStyle.foundersGrotesk(.semibold, size: 18))
                                .foregroundStyle(Color.appBlack)
                        }
                    }
                }
                
                if !isEditing {
                    Button("SAVE DESCRIPTION") {
                        viewModel.updateAvatar {
                            dismiss()
                        }
                    }
                    .disabled(!viewModel.isSubmitEnabled)
                    .frame(maxWidth: .infinity, maxHeight: 48)
                    .frame(height: 48)
                    .font(FontStyle.foundersGrotesk(.semibold, size: 16))
                    .foregroundStyle(.white)
                    .background(viewModel.isSubmitEnabled ? .appBlack : .appBlack.opacity(0.3))
                    .padding(16)
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
            }
        }
    }
}

#Preview {
    UpdateByteView(viewModel: UpdateByteViewModel.new())
        .environmentObject(MainViewModel.new())
}
