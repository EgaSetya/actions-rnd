//
//  AccountSetupView.swift
//  Bythen
//
//  Created by erlina ng on 12/11/24.
//


import SwiftUI

struct AccountSetupView: View {
    @EnvironmentObject var mainState: MainViewModel
    
    @State var isSucceedSaveAccountSetup: Bool = false
    @State var nickname: String = ""
    var didTapClose: () -> Void = {}
    
    var body: some View {
        ZStack {
            Color.totoroGrey300
                .edgesIgnoringSafeArea(.all)
            Color.byteBlack.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
            
            if isSucceedSaveAccountSetup {
                SuccessSaveAccountSetupView(didTapClose: { didTapClose()}, nickname: nickname)
            } else {
                AccountSetupContentView(
                    viewModel: AccountSetupContentViewModel.new(),
                    didSuccessSaveAccountSetup: { string in
                        isSucceedSaveAccountSetup = true
                        nickname = string
                    }
                )
            }
        }
    }
}

#Preview {
    AccountSetupView()
        .environmentObject(MainViewModel.new())
}
