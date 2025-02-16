//
//  SideMenuProfileViewModel.swift
//  Bythen
//
//  Created by Ega Setya on 06/12/24.
//

struct SideMenuInfoViewModel {
    var name: String = ""
    var imageURL: String = ""
    var walletAddress: String = ""
    var appVersion: String = ""
    
    func getName() -> String {
        if name != "" {
            return name
        }
        
        return walletAddress
    }
}
