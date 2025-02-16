//
//  HiveDashboardBottomSheetViewModel.swift
//  Bythen
//
//  Created by Darindra R on 09/12/24.
//

import Foundation

final class HiveDashboardBottomSheetViewModel: ObservableObject {
    
    var displayBeaconPoints: String {
        let beaconPoints = rank.beaconPoints
        
        if beaconPoints > 10 {
            return "10"
        }
        
        return "\(beaconPoints)"
    }
    
    static func new(rank: HiveRank) -> HiveDashboardBottomSheetViewModel {
        return HiveDashboardBottomSheetViewModel(rank: rank, hiveService: HiveService(), staticService: StaticAssetsService())
    }
    
    let rank: HiveRank
    let account = AppSession.shared.getCurrentAccount()
    
    var dismissView: () -> Void = {}

    private let hiveService: HiveServiceProtocol
    private let staticService: StaticAssetsServiceProtocol

    init(
        rank: HiveRank,
        hiveService: HiveServiceProtocol,
        staticService: StaticAssetsServiceProtocol
    ) {
        self.rank = rank
        self.hiveService = hiveService
        self.staticService = staticService
    }

    @Published private(set) var products: [HiveProduct] = []
    @Published private(set) var commision: HiveRankCommision?
    @Published private(set) var progressRules: [String: HiveRankRule] = [:]
    @Published private(set) var maxProgressSlot: Int = 10

    var directCommisionPercentage: String {
        if let commision {
            if commision.directCommision.isNotEmpty {
                return commision.directCommision
            }
        }

        return "--"
    }

    var passupCommissionPercentage: String {
        if let commision {
            if commision.passupCommision.isNotEmpty {
                return commision.passupCommision
            }
        }

        return "--"
    }

    var pairingCommissionPercentage: String {
        if let commision {
            if commision.pairingCommision.isNotEmpty {
                return commision.pairingCommision
            }
        }

        return "--"
    }

    var username: String {
        if let account {
            if account.username.isNotEmpty {
                return account.username
            }
        }

        return "--"
    }

    @MainActor
    func onAppear() async {
        await fetchProducts()
        await fetchRankRules()
    }

    @MainActor
    func fetchProducts() async {
        do {
            let response: HiveProductResponse = try await hiveService.getHiveProducts()
            products = response.products
        } catch {
            Logger.logDebug("Error fetching products: \(error)")
        }
    }

    @MainActor
    func fetchRankRules() async {
        guard let response: HiveRankRulesResponse = try? await staticService.getAssets(path: .hiveRankRules) else { return }

        if rank.activeStatus {
            commision = response.commisions["\(rank.tier)"]
        } else {
            commision = response.commisions["inactive"]
        }

        progressRules = response.rules
        maxProgressSlot = response.maxSlot
    }
}
