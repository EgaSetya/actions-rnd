//
//  SwiftUIView.swift
//  Bythen
//
//  Created by edisurata on 13/09/24.
//

import SwiftUI

struct MyCollectionTabView<Content: View>: View {
    @Binding var selectedTab: Int
    var titles: [String]
    var content: () -> Content
    @State private var indicatorTab: Int = 0
    @FocusState var isFocused: Bool
    @Binding var isEnableFirstTab: Bool
    
    init(selectedTab: Binding<Int>, titles: [String], @ViewBuilder content: @escaping () -> Content, isEnableFirstTab: Binding<Bool>) {
        self._selectedTab = selectedTab
        self.titles = titles
        self.content = content
        self._isEnableFirstTab = isEnableFirstTab
    }
    
    var body: some View {
        VStack(spacing: 0) {
            MyCollectionTabIndicator(
                pageIndicatorIdx: $indicatorTab,
                titles: titles
            )
            .padding(.top, 10)
            
            TabView(selection: $indicatorTab) {
                content()
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onChange(of: indicatorTab) { newValue in
                selectedTab = newValue
            }
            .disabled(indicatorTab == 0 && !isEnableFirstTab)
        }
    }
}

#Preview {
    @State var selectedTab = 0
    
    return MyCollectionTabView(
        selectedTab: $selectedTab,
        titles: ["BYTE", "INFO", "SUMMARY"],
        content: {
            Text("PAGE 1")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.yellow)
                .tag(0)
            Text("PAGE 2").tag(1)
            Text("PAGE 3").tag(2)
        },
        isEnableFirstTab: .constant(true))
        .background(.green)
}
