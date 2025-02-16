//
//  NotificationListEmptyMessageView.swift
//  Bythen
//
//  Created by Darul Firmansyah on 06/02/25.
//

import SwiftUI

struct NotificationListEmptyMessageView: View {
    var body: some View {
        VStack(spacing: 4) {
            // Image
            if let emptyImage = UIImage(named: "notif_list_empty") {
                Image(uiImage:  emptyImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 156, height: 156)
                    .padding(.bottom, 8)
            }
            
            // Title
            Text("It’s quiet for now")
                .font(FontStyle.neueMontreal(.medium, size: 16))
                .foregroundStyle(.byteBlack)
                .padding(.bottom, 5)
            
            // Description
            Text("We’ll let you know if something comes up")
                .font(FontStyle.neueMontreal(.medium, size: 16))
                .foregroundStyle(.byteBlack.opacity(0.5))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)

            Spacer()
        }
        .padding()
    }
}

struct ContentView: View {
    var body: some View {
        NotificationListEmptyMessageView()
            .padding()
    }
}

struct EmptyMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
