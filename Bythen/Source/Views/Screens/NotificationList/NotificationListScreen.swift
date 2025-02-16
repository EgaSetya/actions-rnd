//
//  NotificationListScreen.swift
//  Bythen
//
//  Created by Darul Firmansyah on 05/02/25.
//

import SwiftUI

struct NotificationListScreen: View {
    @Environment(\.dismiss)
    private var dismiss
    
    @ObservedObject
    var viewModel = NotificationListViewModel()
    
    var body: some View {
        VStack {
            // Header Section
            headerSection
            contentSection
        }
    }
    
    var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(
                action: {
                    dismiss()
                }
            ) {
                Image(systemName: "xmark")
                    .foregroundStyle(.byteBlack)
                    .frame(width: 24, height: 24)
            }
            .tint(.white)

            Text("Notification".uppercased())
                .font(FontStyle.foundersGrotesk(.medium, size: 28))
                .foregroundColor(.byteBlack)
            
            // Filter Section
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(NotificationListFilter.allCases, id: \.self) { filter in
                        Text(filter.stringRepresentable)
                            .font(FontStyle.foundersGrotesk(.medium, size: 16))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(viewModel.selectedFilter == filter ? Color.byteBlack : Color.byteBlack.opacity(0.05))
                            .foregroundColor(viewModel.selectedFilter == filter ? Color.white : Color.black)
                            .clipShape(.capsule)
                            .onTapGesture {
                                viewModel.onFilterSelected(filter)
                            }
                    }
                }
            }
        }
        .contentShape(Rectangle())
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    @ViewBuilder
    var contentSection: some View {
        if viewModel.pageState == .initialLoading {
            MissionListShimmerView()
                .onAppear {
                    Task {
                        await viewModel.onAppear()
                    }
                }
        }
        else {
            List {
                ForEach(viewModel.filterredItems.keys.sorted(), id: \.self) { key in
                    Section(
                        header:
                            Text(key.uppercased())
                            .font(FontStyle.foundersGrotesk(.medium, size: 14))
                            .background(.white)
                            .foregroundColor(.byteBlack.opacity(0.6))
                    ) {
                        ForEach(viewModel.filterredItems[key] ?? [], id: \.id) { notification in
                            Text("\(notification.title) - \(notification.type.stringRepresentable)")
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listSectionSeparator(.hidden)
                }
                
                if viewModel.pageState == .paginationLoading {
                    Section {
                        HStack {
                            ProgressView()
                                .frame(width: 44, height: 44)
                            .onAppear {
                                Task {
                                    await viewModel.loadMoreContent()
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .listRowSeparator(.hidden)
                    .listSectionSeparator(.hidden)
                }
            }
            .listRowSeparatorTint(.clear)
            .listSectionSeparatorTint(.clear)
            .scrollContentBackground(.hidden)
            .background(Color.white)
            .listStyle(GroupedListStyle())
            .overlay {
                if viewModel.pageState == .empty {
                    NotificationListEmptyMessageView()
                }
            }
        }
        
        Spacer()
    }
}
