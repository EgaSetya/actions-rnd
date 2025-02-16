//
//  HiveWithdrawalsInfo.swift
//  Bythen
//
//  Created by Ega Setya on 03/02/25.
//

struct HiveWithdrawalsInfo: Codable {
    let totalPoint: Int
    let totalPointEth, totalPointUsd, gasFeeEth, gasFeeUsd: String
    let amountReceivedEth, amountReceivedUsd: String

    enum CodingKeys: String, CodingKey {
        case totalPoint = "total_point"
        case totalPointEth = "total_point_eth"
        case totalPointUsd = "total_point_usd"
        case gasFeeEth = "gas_fee_eth"
        case gasFeeUsd = "gas_fee_usd"
        case amountReceivedEth = "amount_received_eth"
        case amountReceivedUsd = "amount_received_usd"
    }
}
