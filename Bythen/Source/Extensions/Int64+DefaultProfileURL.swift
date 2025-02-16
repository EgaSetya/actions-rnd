//
//  Int64+DefaultProfileURL.swift
//  Bythen
//
//  Created by Ega Setya on 16/12/24.
//

extension Int64 {
    func createDefaultImageReplacementURL() -> String {
        let placeholderImageNumber = (self % 3 + 3) % 3 + 1
        
        return "https://assets.bythen.ai/general/profile-\(placeholderImageNumber).png"
    }
}
