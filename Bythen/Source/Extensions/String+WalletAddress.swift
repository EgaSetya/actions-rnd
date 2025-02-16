//
//  String+WalletAddress.swift
//  Bythen
//
//  Created by Ega Setya on 18/12/24.
//

extension String {
    var hiddenWalletAddress: String {
        let prefix = self.prefix(6)
        let postfix = self.suffix(3)
        
        return prefix + "..." + postfix
    }
}
