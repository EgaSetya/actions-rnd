//
//  roomsView.swift
//  Bythen
//
//  Created by edisurata on 18/09/24.
//

import SwiftUI

struct RoomsItemContextMenu: View {
    
    var renameAction: () -> Void
    var deleteAction: () -> Void
    
    var body: some View {
        Button(action: {
            renameAction()
        }, label: {
            Label {
                Text("Rename")
                    .font(FontStyle.neueMontreal(size: 14))
                    .foregroundStyle(.byteBlack)
            } icon: {
                Image("stylus")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.byteBlack)
                    .frame(width: 24, height: 24)
            }

        })
        
        Button(role: .destructive, action: {
            deleteAction()
        }, label: {
            Label {
                Text("Delete")
                    .font(FontStyle.neueMontreal(size: 14))
                    .foregroundStyle(.elmoRed500)
            } icon: {
                Image("delete")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.elmoRed500)
                    .frame(width: 24, height: 24)
            }
        })
    }
}

struct BytesItemContextMenu: View {
    
    var setPrimaryAction: () -> Void
    
    var body: some View {
        Button(action: {
            setPrimaryAction()
        }, label: {
            Label("Set As Primary", image: "set-as-primary")
        })
    }
}

struct RoomsView: View {
    @EnvironmentObject var mainState: MainViewModel
    @StateObject var viewModel: RoomsViewModel
    @Binding var isPresent: Bool
    @State var isShowRoomsTooltip: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            if viewModel.isShowBackground {
                Color.appBlack.opacity(0.7)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture(perform: dismissView)
            }
            VStack(alignment: .trailing) {
                Button { dismissView() } label: {
                    Image("close")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 14, height: 14)
                        .foregroundStyle(.white)
                        .padding(14)
                        .background(
                            Circle().fill(.ghostWhite300)
                        )
                }
                .padding(.leading, 16)
                .padding(.bottom, 14)
                .padding(.trailing, 12)
                
                VStack {
                    RoomsSearchBar(
                        searchText: $viewModel.searchText,
                        searchTextDidChange: viewModel.filterBytesAndRooms(filterText:)
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 32)
                    .padding(.bottom, 8)
                    
                    ScrollView {
                        VStack {
                            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                                Section {
                                    ForEach(viewModel.byteItems, id: \.id) { byteItem in
                                        ByteItemView(viewModel: byteItem)
                                    }
                                } footer: {
                                    Rectangle()
                                        .fill(.appBlack.opacity(0.1))
                                        .frame(maxWidth: .infinity, maxHeight: 1)
                                        .padding(8)
                                }
                                
                                Section {
                                    ForEach(viewModel.roomItems, id: \.self) { roomItem in
                                        ZStack {
                                            if roomItem.isSelected {
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(.appBlack.opacity(0.05))
                                                    .frame(maxWidth: .infinity, maxHeight: 60)
                                                    .padding(.horizontal, 12)
                                            }
                                            
                                            RoomItemView(viewModel: roomItem)
                                        }
                                        
                                    }
                                } header: {
                                    HStack {
                                        Text("ROOMS")
                                            .font(FontStyle.foundersGrotesk(.semibold, size: 18))
                                        Button(action: {
                                            isShowRoomsTooltip = true
                                        }, label: {
                                            Image("info")
                                                .resizable()
                                                .frame(width: 16, height: 16)
                                                .foregroundStyle(.appBlack)
                                        })
                                        Spacer()
                                        Button(action: {
                                            viewModel.createNewRoom()
                                            withAnimation {
                                                viewModel.isShowBackground = false
                                                isPresent = false
                                            }
                                        }, label: {
                                            Image(AppImages.kEditSquare)
                                                .resizable()
                                                .frame(width: 16, height: 16)
                                        })
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, maxHeight: 48, alignment: .leading)
                                    .background(.white)
                                    .overlay {
                                        if isShowRoomsTooltip {
                                            Tooltip(content: "You can create separate rooms to discuss different topics with your Byte, allowing you to segment conversations and continue discussions focused on specific subjects.")
                                                .frame(width: 250, height: 120, alignment: .leading)
                                                .zIndex(1)
                                                .offset(x: 20)
                                                .onTapGesture {
                                                    isShowRoomsTooltip = false
                                                }
                                                .onAppear {
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                                        isShowRoomsTooltip = false
                                                    }
                                                }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .transition(.move(edge: .bottom))
                .onAppear(perform: {
                    viewModel.isShowBackground = true
                    viewModel.setMainState(state: mainState)
                    viewModel.fetchData()
                })
                .onDisappear {
                    isShowRoomsTooltip = false
                }
            }
            switch viewModel.roomsAlert {
            case .deleteRoom:
                AlertView(
                    didDismiss: {
                        viewModel.roomsAlert = .hidden
                    },
                    title: "Delete Room?",
                    content: viewModel.roomsAlert.content ?? "",
                    actionType: .delete,
                    actionTitle: "DELETE",
                    action: viewModel.deleteRooms
                )
                .zIndex(1)
            case .renameRoom:
                AlertView(
                    didDismiss: {
                        viewModel.roomsAlert = .hidden
                    },
                    title: "Rename Title",
                    actionTitle: "OK",
                    action: {},
                    isEditMode: true,
                    editText: viewModel.roomsAlert.editText ?? "",
                    editTextHanlder: viewModel.updateRooms(newTitle:)
                )
                .zIndex(1)
            default:
                EmptyView()
            }
        }
    }
    
    func dismissView() {
        viewModel.isShowBackground = false
        withAnimation {
            isPresent = false
        }
    }
}

#Preview {
    let vm = RoomsViewModel.new(buildID: 7, byteID: 1, selectByteAction: { _ in }, selectRoomAction: { _ in })
    
    @State var isPresent = true
    
    return ZStack {
        Button("Show") {
            isPresent = true
        }
        
        VStack {
            if isPresent {
                RoomsView(viewModel: vm, isPresent: $isPresent)
                    .environmentObject(MainViewModel.new())
            }
        }
    }
    .background(.green)
    
}
