//
//  ByteRadioButton.swift
//  Bythen
//
//  Created by erlina ng on 02/10/24.
//

import SwiftUI
struct ByteRadioButton: View {
    @Binding var checked: Bool
    
    var body: some View {
        Group{
            if checked {
                ZStack{
                    Circle()
                        .fill(Color.black)
                        .frame(width: 16, height: 16)
                    Circle()
                        .fill(Color.white)
                        .frame(width: 4, height: 4)
                }
            } else {
                Circle()
                    .fill(Color.white)
                    .frame(width: 16, height: 16)
                    .overlay( Circle().stroke(Color.black, lineWidth: 1.5) )
            }
        }
    }
}
