//
//  WrapHStack.swift
//  Bythen
//
//  Created by edisurata on 14/10/24.
//

import SwiftUI

struct FlowLayout<Content: View, Item: Hashable>: View {
    let items: [Item]
    let content: (Item) -> Content

    @State private var totalHeight = CGFloat.zero

    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
        .frame(height: totalHeight)
    }

    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(self.items, id: \.self) { item in
                self.content(item)
                    .alignmentGuide(.leading, computeValue: { d in
                        if abs(width - d.width) > geometry.size.width {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if item == self.items.last! {
                            width = 0 // Last item reset width
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { _ in
                        let result = height
                        if item == self.items.last! {
                            height = 0 // Reset height
                        }
                        return result
                    })
            }
        }
        .background(viewHeightReader($totalHeight)) // Track the total height of the view
    }
    
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geo in
            Color.clear
                .preference(key: HeightPreferenceKey.self, value: geo.size.height)
                .onPreferenceChange(HeightPreferenceKey.self) { value in
                    binding.wrappedValue = value
                }
        }
    }
}

// Preference key to track height
struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}



#Preview {
    let items = ["AMERICAN", "BRITISH", "AFRICAN", "INDIAN", "AUSTRALIAN"]
    VStack {
        FlowLayout(items: items) { item in
            Text(item)
                .padding()
                .background(Color.orange)
                .cornerRadius(10)
        }
    }
}
