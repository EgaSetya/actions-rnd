//
//  HiveWithdrawals.swift
//  Bythen
//
//  Created by Ega Setya on 31/01/25.
//


// MARK: - HiveWithdrawals
struct HiveWithdrawals: Codable {
    let withdrawals: [Withdrawal]
    let page, totalPage, totalData: Int

    enum CodingKeys: String, CodingKey {
        case withdrawals, page
        case totalPage = "total_page"
        case totalData = "total_data"
    }
}

// MARK: - Withdrawal
struct Withdrawal: Codable {
    let id, accountID, totalPoint: Int
    let status, statusTitle, amountReceived: String
    
    @DefaultEmptyString var gasFee: String
    @DefaultEmptyString var trxHash: String
    @DefaultEmptyString var createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case accountID = "account_id"
        case totalPoint = "total_point"
        case status
        case statusTitle = "status_title"
        case amountReceived = "amount_received"
        case gasFee = "gas_fee"
        case trxHash = "trx_hash"
        case createdAt = "created_at"
    }
}
