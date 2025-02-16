//
//  Int+toMegaBytes.swift
//  Bythen
//
//  Created by Ega Setya on 02/01/25.
//

extension Int {
    func toMegaBytes() -> Double { Double(self) / (1024.0 * 1024.0) }
}
