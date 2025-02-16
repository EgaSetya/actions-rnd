//
//  CircularImageView.swift
//  Bythen
//
//  Created by edisurata on 18/09/24.
//

import SwiftUI

struct CircularImageView: View {
    var urlString: String
    
    var body: some View {
        CachedAsyncImage(urlString: urlString)
            .background(.appCream)
            .clipShape(Circle())
    }
}

#Preview {
    VStack {
        CircularImageView(urlString: "")
    }.background(.green)
}
