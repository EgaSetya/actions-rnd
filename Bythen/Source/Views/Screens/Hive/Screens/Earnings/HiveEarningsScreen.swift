//
//  HiveEarningsScreen.swift
//  Bythen
//
//  Created by Ega Setya on 21/01/25.
//

import SwiftUI

enum HiveEarningsViewState {
    case idle
    case loading
    case dataRetrieved
    case confirmationLoading
    case confirmationShow
    case withdrawLoading
    case withdrawDone
    case showHoneyTooltip
}

enum HiveEarningListViewState {
    case idle
    case listEmpty
    case listLoading
    case listDataRetrieved
}

struct HiveEarningsScreen: View {
    private var honeyCard: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Honey")
                    .font(.dmMono(size: 14))
                    .foregroundStyle(.ghostWhite500)
                
                Spacer()
                
                Button {
                    showHoneyTooltip()
                } label: {
                    Image(systemName: "info.circle")
                        .frame(square: 16)
                        .foregroundStyle(.ghostWhite500)
                }.tooltip(viewModel.viewState == .showHoneyTooltip, side: .left) {
                    Text("70% of the Honey you’ve earned in Bytes Hive, can be withdrawn to your connected wallet.")
                        .lineLimit(nil)
                        .font(Font.neueMontreal(.regular, size: 12))
                        .foregroundStyle(Color.white)
                        .multilineTextAlignment(.leading)
                }
            }
            .frame(maxWidth: .infinity)
            .zIndex(1)
            
            Group {
                if let honeyViewModel = viewModel.honeyViewModel {
                    HStack(alignment: .bottom, spacing: 8) {
                        Text(honeyViewModel.honeyCount)
                            .font(.foundersGrotesk(.semibold, size: 32))
                            .foregroundStyle(.white)
                        
                        Text(honeyViewModel.usdValue)
                            .font(.dmMono(size: 14))
                            .foregroundStyle(.ghostWhite500)
                            .padding(.bottom, 4)
                    }
                }
            }
            
            Group {
                if viewModel.viewState == .confirmationLoading {
                    NetworkProgressView(size: 20)
                        .frame(height: 40, alignment: .center)
                } else {
                    createWithdrawButton(isEnabled: viewModel.shouldEnableWithdrawButton)
                }
            }
            .frame(width: 115)
        }
        .frame(height: 150)
        .padding(20)
        .background(.appBlack)
    }
    
    private var alertLabel: some View {
        Group {
            if let alertText = viewModel.earningsAlertText {
                HStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .frame(width: 24, height: 22.5)
                        .fontWeight(.bold)
                        .foregroundStyle(.gokuOrange600)
                        .padding(.vertical, 21)
                        .padding(.leading, 16)
                    
                    Text(alertText)
                        .font(.neueMontreal(size: 14))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(.white)
                        .padding(.vertical, 12)
                        .padding(.trailing, 16)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(minHeight: 64)
                .background(.ghostWhite200)
            } else {
                EmptyView()
            }
        }
    }
    
    private var listTabButtons: some View {
        HStack(spacing: 0) {
            ForEach(HiveEarningsType.allCases, id: \.title) { type in
                createTabButton(title: type.rawValue.uppercased(), isSelected: viewModel.selectedListType == type) {
                    viewModel.changeList(type: type)
                }
            }
            
            Spacer()
        }
        .padding(.top, 40)
        .padding(.bottom, 24)
        .padding(.horizontal, 16)
    }
    
    @EnvironmentObject var mainState: MainViewModel
    
    @StateObject var viewModel: HiveEarningsViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                honeyCard
                    .padding(16)
                
                alertLabel
                
                VStack(alignment: .leading, spacing: 0) {
                    listTabButtons
                        .frame(maxWidth: .infinity)
                    
                    switch viewModel.listState {
                    case .listEmpty:
                    VStack(alignment: .center) {
                            Image("hive-commission-empty")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(Color.white.opacity(0.8))
                                .frame(height: 24)
                            
                            Text("No activity has been recorded.")
                                .lineLimit(nil)
                                .multilineTextAlignment(.center)
                                .font(Font.neueMontreal(.regular, size: 12))
                                .foregroundStyle(Color.white.opacity(0.4))
                                .padding(.top, 12)
                        }
                        .frame(height: 250)
                        .frame(maxWidth: .infinity)
                    case .listLoading:
                        NetworkProgressView()
                            .frame(maxWidth: .infinity)
                            .frame(height: 400)
                    case .idle, .listDataRetrieved:
                        createListHeader()
                        
                        createList()
                        
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity)
                .background(.black)
            }
            .frame(maxWidth: .infinity)
            .background(
                Rectangle().fill(.appBlack).overlay {
                    Color(.ghostWhite100)
                }.edgesIgnoringSafeArea(.all)
            )
        }
        .background(.black)
        .embedHiveNavigationBar()
        .overlay {
            if viewModel.viewState == .confirmationShow || viewModel.viewState == .withdrawLoading {
                HiveWithdrawalConfirmationModal(viewModel: $viewModel.withdrawalConfirmationViewModel, didTapClose: {
                    hideConfirmationModal()
                }, withdrawTapped: {
                    viewModel.withdraw()
                })
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
            
            if viewModel.viewState == .loading {
                NetworkProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.appBlack)
            }
            
            showWithdrawalSuccessBanner()
        }
        .onAppear {
            viewModel.setMainState(state: mainState)
            viewModel.onAppear()
        }
        .animation(.easeInOut(duration: 0.25), value: viewModel.viewState)
    }
    
    private func createWithdrawButton(isEnabled: Bool) -> some View {
        Button {
            viewModel.processWidthdrawalInfo()
        } label: {
            HStack(spacing: 8) {
                Image("withdraw")
                    .frame(square: 14)
                
                Text("WITHDRAW")
                    .font(.foundersGrotesk(.semibold, size: 16))
                    .foregroundStyle(Color.byteBlack1000)
            }
            .padding(12)
            .background(isEnabled ? HiveColors.buttonYellow : .ghostWhite500)
        }
        .disabled(!isEnabled)
    }
    
    private func createTabButton(title: String, isSelected: Bool = false, action: @escaping (() -> Void)) -> some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.foundersGrotesk(.semibold, size: 24))
                .foregroundStyle(isSelected ? .white : .ghostWhite500)
        }.padding(.trailing, 24)
    }
    
    private func createListHeader() -> some View {
        Group {
            HStack {
                let selectedListType = viewModel.selectedListType
                
                Text(selectedListType.title)
                
                if selectedListType == .withdrawal {
                    Spacer()
                    
                    Text("GAS FEE")
                    
                    Spacer()
                    
                    Text("RECEIVED")
                } else {
                    Spacer()
                    
                    Text("AMOUNT")
                }
            }
            .font(.foundersGrotesk(.semibold, size: 16))
            .foregroundStyle(.ghostWhite500)
            .frame(maxWidth: .infinity)
            .frame(height: 20)
            .padding(.horizontal, 16)
        }
    }
    
    private func createList() -> some View {
        Group {
            ForEach(viewModel.listItemViewModels, id: \.id) { itemViewModel in
                createCell(itemViewModel)
            }
            
            HStack(alignment: .center) {
                Text(viewModel.listItemsPageText)
                    .font(.neueMontreal(size: 16))

                Spacer()
                
                Group {
                    Button {
                        viewModel.getListPreviousPage()
                    } label: {
                        Image(systemName: "chevron.left")
                            .padding(8)
                    }
                    .disabled(viewModel.isListPreviousButtonEnabled)
                    
                    Button {
                        viewModel.getListNextPage()
                    } label: {
                        Image(systemName: "chevron.right")
                            .padding(8)
                    }
                    .disabled(viewModel.isListNextButtonEnabled)
                }
                .isHidden(viewModel.shouldHidePrevNextButton)
            }
            .foregroundStyle(.white.opacity(0.5))
            .padding(.top, 8)
            .padding(.bottom, 16)
        }
        .padding(.top, 24)
        .padding(.horizontal, 16)
        .foregroundStyle(.white)
    }
    
    private func createCell(_ itemViewModel: HiveEarningListItemViewModel) -> some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .leading) {
                Text(itemViewModel.title)
                    .font(.neueMontreal(.bold, size: 16))
                
                Text(itemViewModel.subtitle)
                    .font(.neueMontreal(size: 12))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if let gasFeeText = itemViewModel.gasFee {
                Text(gasFeeText)
                    .font(.neueMontreal(.bold, size: 18))
                    .frame(width: 75, alignment: .trailing)
            }
            
            VStack(alignment: .trailing) {
                Text(itemViewModel.amount)
                    .font(.neueMontreal(.bold, size: 18))
                
                if let subAmount = itemViewModel.subAmount {
                    Text(subAmount)
                        .font(.dmMono(size: 11))
                        .foregroundStyle(.ghostWhite500)
                }
                
                if let statusText = itemViewModel.status {
                    Text(statusText)
                        .font(.neueMontreal(size: 12))
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
    
    private func createListEmptyState() -> some View {
        VStack {
            Image("hive-commission-empty")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color.white.opacity(0.4))
                .frame(height: 24)
            
            Text("No activity has been recorded.")
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .font(Font.neueMontreal(.regular, size: 12))
                .foregroundStyle(Color.white.opacity(0.4))
                .padding(.top, 12)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 12)
        .padding(.vertical, 46)
        .background(Color.byteBlack)
    }
    
    private func hideConfirmationModal() {
        withAnimation(.easeInOut(duration: 0.5)) {
            viewModel.updateViewState(to: .idle)
        }
    }
    
    private func showWithdrawalSuccessBanner() -> some View {
        Group {
            if viewModel.viewState == .withdrawDone {
                VStack {
                    Banner.customView(
                        HiveToasterView(text: viewModel.withdrawSuccessText) {
                            viewModel.updateViewState(to: .idle)
                        }
                    ).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }.onAppear {
                    viewModel.updateViewState(to: .idle, delay: 2.0)
                }
            }
        }
    }
    
    private func showHoneyTooltip() {
        viewModel.updateViewState(to: .showHoneyTooltip)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            viewModel.updateViewState(to: .idle)
        }
    }
}
