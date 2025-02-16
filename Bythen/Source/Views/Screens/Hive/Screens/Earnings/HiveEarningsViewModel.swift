//
//  HiveEarningsViewModel.swift
//  Bythen
//
//  Created by Ega Setya on 21/01/25.
//

import Foundation
import Combine

enum HiveEarningsType: String, CaseIterable {
    case earning
    case withdrawal
    case nectar
    
    var title: String {
        switch self {
        case .earning: "SOURCE"
        case .withdrawal: "WITHDRAWN"
        case .nectar: "BONUS"
        }
    }
}

struct HiveEarningHoneyViewModel {
    let honeyCount: String
    let usdValue: String
}

struct HiveEarningListItemViewModel: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    var gasFee: String? = nil
    let amount: String
    var subAmount: String? = nil
    var status: String? = nil
}

struct HiveWithdrawalConfirmationViewModel {
    var honeyText: String = ""
    var ethText: String = ""
    var usdText: String = ""
    var gasFeeEthText: String = ""
    var gasFeeUSDText: String = ""
    var receivedEthText: String = ""
    var receivedUSDText: String = ""
}

protocol HiveEarningsViewModelInput {
    func onAppear()
    func changeList(type: HiveEarningsType)
    func getListPreviousPage()
    func getListNextPage()
    func updateViewState(to newState: HiveEarningsViewState, delay: TimeInterval)
    func processWidthdrawalInfo()
    func withdraw()
}

protocol HiveEarningsViewModelOutput {
    var viewState: HiveEarningsViewState { get }
    var listState: HiveEarningListViewState { get }
    var selectedListType: HiveEarningsType { get }
    var honeyViewModel: HiveEarningHoneyViewModel? { get }
    var listItemViewModels: [HiveEarningListItemViewModel] { get }
    var withdrawalConfirmationViewModel: HiveWithdrawalConfirmationViewModel { get }
    var earningsAlertText: String? { get }
    var withdrawSuccessText: String { get }
    var listItemsPageText: String { get }
    var isListPreviousButtonEnabled: Bool { get }
    var isListNextButtonEnabled: Bool { get }
    var shouldHidePrevNextButton: Bool { get }
    var shouldEnableWithdrawButton: Bool { get }
}

class HiveEarningsViewModel: BaseViewModel, HiveEarningsViewModelOutput {
    @Published var viewState: HiveEarningsViewState = .idle
    @Published var listState: HiveEarningListViewState = .idle
    var selectedListType: HiveEarningsType = .earning
    var honeyViewModel: HiveEarningHoneyViewModel?
    var listItemViewModels: [HiveEarningListItemViewModel] = []
    var withdrawalConfirmationViewModel: HiveWithdrawalConfirmationViewModel = HiveWithdrawalConfirmationViewModel()
    var earningsAlertText: String?
    var withdrawSuccessText = ""
    var listItemsPageText = ""
    var isListPreviousButtonEnabled = true
    var isListNextButtonEnabled = true
    var shouldHidePrevNextButton: Bool { isListPreviousButtonEnabled && isListNextButtonEnabled }
    @Published var shouldEnableWithdrawButton: Bool = true
    
    private var currentEarningPage = 1
    private var currentWithdrawalPage = 1
    private var currentNectarPage = 1
    
    private let hiveService = HiveService()
    private let milesService = MilesService()
    private let byteService = ByteService()
    
    private func getHiveSummary(page: Int = 1) {
        updateViewState(to: .loading)
        Task { @MainActor [weak self] in
            guard let self else { return }
            do {
                let summary = try await hiveService.getHiveSummary(page: page, limit: 5, aggregate: true)
                let expiredPoints = try await hiveService.getExpiredPoints()
                
                shouldEnableWithdrawButton = await shouldEnableWithdrawButton(summary.aggregate?.totalUnlockedPoint ?? 0)
                handleGetHiveSummarySuccess(summary, expiredPoints: expiredPoints)
            } catch let err as HttpError {
                showError(err)
                
                updateViewState(to: .idle)
            }
        }
    }
    
    private func handleGetHiveSummarySuccess(_ summary: HiveCommision, expiredPoints: HiveExpiredPoints) {
        if let aggregate = summary.aggregate {
            honeyViewModel = HiveEarningHoneyViewModel(honeyCount: "\(aggregate.totalUnlockedPoint)".formatNumberString(), usdValue: "($\(aggregate.totalUnlockedPointUSD.formatNumberString()))")
            
            let expiredMessage = expiredPoints.message
            earningsAlertText = expiredMessage.isTrulyEmpty ? nil : expiredMessage
        }
        
        handleGetPointsSuccess(summary)
        
        updateViewState(to: .dataRetrieved)
    }
    
    private func getPoints(page: Int = 1) {
        updateListState(to: .listLoading)
        
        Task { [weak self] in
            guard let self else { return }
            do {
                let points = try await hiveService.getHiveSummary(page: page, limit: 5, aggregate: true)
                
                await MainActor.run {
                    self.handleGetPointsSuccess(points)
                }
            } catch let err as HttpError {
                showError(err)
                
                updateViewState(to: .idle)
            }
        }
    }
    
    private func handleGetPointsSuccess(_ points: HiveCommision) {
        if points.hivePoints.isEmpty {
            updateListState(to: .listEmpty)
        } else {
            listItemViewModels = points.hivePoints.compactMap { point in
                HiveEarningListItemViewModel(
                    title: point.rewardTypeTitle,
                    subtitle: "\(point.createdAt.convertToDateFormat(to: "dd/MM/yyyy"))・\(point.sourceUsername)",
                    amount: "\(point.totalPoint)",
                    subAmount: "($\(point.totalPointUSD))"
                )
            }
            
            listItemsPageText = "\(currentEarningPage) of \(points.totalPage) displayed"
            isListPreviousButtonEnabled = !(currentEarningPage > 1 && currentEarningPage <= points.totalPage)
            isListNextButtonEnabled = !(currentEarningPage < points.totalPage)
            
            updateListState(to: .listDataRetrieved)
        }
    }
    
    private func getWithdrawals(page: Int = 1) {
        updateListState(to: .listLoading)
        Task {[weak self] in
            guard let self else { return }
            
            do {
                let withdrawalsResponse = try await hiveService.getWithdrawals(page: page, limit: 5)
                
                await MainActor.run {
                    self.handleWithdrawalSuccess(withdrawalsResponse)
                }
            }  catch let err as HttpError {
                showError(err)
                
                updateViewState(to: .idle)
            }
        }
    }
    
    private func handleWithdrawalSuccess(_ withdrawalsResponse: HiveWithdrawals) {
        if withdrawalsResponse.withdrawals.isEmpty {
            updateListState(to: .listEmpty)
        } else {
            listItemViewModels = withdrawalsResponse.withdrawals.compactMap { withdrawal in
                HiveEarningListItemViewModel(
                    title: "\(withdrawal.totalPoint) Honey",
                    subtitle: withdrawal.createdAt.convertToDateFormat(to: "dd/MM/yyyy"),
                    gasFee: "\(withdrawal.gasFee) ETH",
                    amount: "\(withdrawal.amountReceived) ETH",
                    status: withdrawal.statusTitle
                )
            }
            
            listItemsPageText = "\(currentWithdrawalPage) of \(withdrawalsResponse.totalPage) displayed"
            isListPreviousButtonEnabled = !(currentWithdrawalPage > 1 && currentWithdrawalPage <= withdrawalsResponse.totalPage)
            isListNextButtonEnabled = !(currentWithdrawalPage < withdrawalsResponse.totalPage)
            
            updateListState(to: .listDataRetrieved)
        }
    }
    
    private func getNectars(page: Int = 1) {
        updateListState(to: .listLoading)
        Task { [weak self] in
            guard let self else { return }
            
            do {
                let nectarsResponse = try await milesService.getNectars(page: page, limit: 5)
                
                await MainActor.run {
                    self.handleGetNectarsSuccess(nectarsResponse)
                }
            } catch let err as HttpError {
                showError(err)
                
                updateViewState(to: .idle)
            }
        }
    }
    
    private func handleGetNectarsSuccess(_ nectarsResponse: Nectars) {
        if nectarsResponse.nectars.isEmpty {
            updateListState(to: .listEmpty)
        } else {
            listItemViewModels = nectarsResponse.nectars.compactMap { nectar in
                let sourceTitle = nectar.sourceTitle ?? ""
                
                return HiveEarningListItemViewModel(
                    title: sourceTitle.isTrulyEmpty ? nectar.source.replacingOccurrences(of: "_", with: " ").capitalized : sourceTitle,
                    subtitle: (nectar.createdAt ?? "").convertToDateFormat(to: "dd/MM/yyyy"),
                    amount: "\(nectar.point) Nectar"
                )
            }
            
            let totalPage = nectarsResponse.pagination?.totalPage ?? 0
            listItemsPageText = "\(currentNectarPage) of \(totalPage) displayed"
            isListPreviousButtonEnabled = !(currentNectarPage > 1 && currentNectarPage <= totalPage)
            isListNextButtonEnabled = !(currentNectarPage < totalPage)
            
            updateListState(to: .listDataRetrieved)
        }
    }
    
    private func shouldEnableWithdrawButton(_ totalUnlockedPoint: Int) async ->  Bool {
        do {
            let hive = try await hiveService.getHiveRank()
            let shouldEnable = !hive.isTrial && totalUnlockedPoint > 10
            
            return shouldEnable
        } catch let err {
            showError(err)
            updateViewState(to: .idle)
            
            return false
        }
    }
    
    private func showError(_ error: Error) {
        handleError(error, showReadable: true)
    }
}

extension HiveEarningsViewModel: HiveEarningsViewModelInput {
    func onAppear() {
        getHiveSummary()
    }
    
    func changeList(type: HiveEarningsType) {
        selectedListType = type
        
        switch type {
        case .earning:
            getPoints(page: currentEarningPage)
        case .withdrawal:
            getWithdrawals(page: currentWithdrawalPage)
        case .nectar:
            getNectars(page: currentNectarPage)
        }
    }
    
    func getListPreviousPage() {
        switch selectedListType {
        case .earning:
            currentEarningPage -= 1
            
            getPoints(page: currentEarningPage)
        case .withdrawal:
            currentWithdrawalPage -= 1
            
            getWithdrawals(page: currentWithdrawalPage)
        case .nectar:
            currentNectarPage -= 1
            
            getNectars(page: currentNectarPage)
        }
    }
    
    func getListNextPage() {
        switch selectedListType {
        case .earning:
            currentEarningPage += 1
            
            getPoints(page: currentEarningPage)
        case .withdrawal:
            currentWithdrawalPage += 1
            
            getWithdrawals(page: currentWithdrawalPage)
        case .nectar:
            currentNectarPage += 1
            
            getNectars(page: currentNectarPage)
        }
    }
    
    func updateViewState(to newState: HiveEarningsViewState, delay: TimeInterval = 0.0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.viewState = newState
        }
    }
    
    func updateListState(to newState: HiveEarningListViewState) {
        listState = newState
    }
    
    func processWidthdrawalInfo() {
        updateViewState(to: .confirmationLoading)
        
        Task { [weak self] in
            guard let self else { return }
            do {
                let withdrawalInfo = try await hiveService.getWithdrawalsInfo()
                
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    
                    withdrawalConfirmationViewModel = HiveWithdrawalConfirmationViewModel(
                        honeyText: "\(withdrawalInfo.totalPoint) HONEY",
                        ethText: "\(withdrawalInfo.totalPointEth) ETH",
                        usdText: "($\(withdrawalInfo.totalPointUsd))",
                        gasFeeEthText: "\(withdrawalInfo.gasFeeEth) ETH",
                        gasFeeUSDText: "-($\(withdrawalInfo.gasFeeUsd))",
                        receivedEthText: "\(withdrawalInfo.amountReceivedEth) ETH",
                        receivedUSDText: "($\(withdrawalInfo.amountReceivedUsd))"
                    )
                    
                    updateViewState(to: .confirmationShow)
                }
            } catch let err as HttpError {
                showError(err)
                
                updateViewState(to: .idle)
            }
        }
    }
    
    func withdraw() {
        updateViewState(to: .withdrawLoading)
        
        Task { [weak self] in
            guard let self else { return }
            do {
                let withdrawal = try await hiveService.withdraw()
                
                await MainActor.run {
                    self.withdrawSuccessText = "Your withdrawal \(withdrawal.amountReceived) ETH is being processed now"
                    self.updateViewState(to: .withdrawDone)
                }
            } catch let err as HttpError {
                showError(err)
                
                updateViewState(to: .idle)
            }
        }
    }
}
