//
//  UserInterestBottomSheetView.swift
//  Bythen
//
//  Created by erlina ng on 05/12/24.
//

import SwiftUI

struct UserInterestBottomSheetView: View {
    @EnvironmentObject var viewModel: AccountSetupContentViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Choose one")
                .font(Font.neueMontreal(.medium, size: 24))
                .foregroundStyle(Color.byteBlack)
                .padding(.leading, 16)
            
            List {
                ForEach(UserInterest.allCases, id: \.rawValue) { userInterest in
                    if userInterest != .none {
                        UserInterestBottomSheetViewCell(
                            name: userInterest.rawValue,
                            selectedValue: $viewModel.selectedUserInterest
                        )
                        .background()
                        .onTapGesture {
                            viewModel.selectedUserInterest = userInterest
                            dismiss()
                        }
                    }
                }
            }
            .listStyle(.plain)
            .padding(.trailing, 16)
        }
        .padding(.top, 24)
        .background(Color.white)
    }
}
