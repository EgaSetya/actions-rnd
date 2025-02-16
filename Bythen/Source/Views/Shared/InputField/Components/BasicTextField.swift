//
//  BasicTextField.swift
//  Bythen
//
//  Created by Ega Setya on 11/12/24.
//

import SwiftUI

struct BasicTextField: View {
    @Binding var text: String
    @Binding var errorText: String
    var placeholder: String
    
    @State private var isError: Bool = false
    @State private var backgroundType: TextFieldBackgroundType = .default
    @FocusState private var isFocused: Bool
    
    private var errorView: some View {
        return Group {
            if !errorText.isTrulyEmpty {
                HStack {
                    Image(systemName: "info.circle")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 13)
                        .foregroundStyle(.elmoRed500)
                    Text(errorText)
                        .font(.neueMontreal(size: 14))
                        .foregroundStyle(.elmoRed500)
                        .multilineTextAlignment(.leading)
                }
            }
            
            EmptyView()
        }.onChange(of: errorText) { newValue in
            isError = !errorText.isTrulyEmpty
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            BaseTextField(text: $text, placeholder: placeholder, isFocused: _isFocused)
                .background {
                    TextFieldBackground(type: $backgroundType)
                }
                .onChange(of: isFocused) { _isFocused in
                    updateBackgroundType()
                }
                .onChange(of: isError) { _isError in
                    updateBackgroundType()
                }
            
            errorView.padding(.top, 8)
        }.animation(.default, value: isError)
    }
    
    private func updateBackgroundType() {
        if isError {
            backgroundType = .error
        } else {
            backgroundType = isFocused ? .focused : .default
        }
    }
}
