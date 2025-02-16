//
//  ByteItemViewModel.swift
//  Bythen
//
//  Created by edisurata on 18/09/24.
//

import Foundation

class ByteItemViewModel: BaseViewModel {
    
    typealias ByteItemHandler = (_ byte: Byte) -> Void
    
    var didSelectByte: ByteItemHandler
    var didSetAsPrimary: ByteItemHandler
    
    @Published var isSelected: Bool = false
    @Published var isPrimary: Bool = false
    @Published var highlightedText: String?
    
    var imageUrl: String = ""
    var name: String = ""
    var roles: String = ""
    var buildID: Int64 = 0
    var byteID: Int64 = 0
    
    private var byte: Byte
    
    init(byte: Byte, index: Int, isSelected: Bool = false, highlightedText: String? = nil, didSelectByte: @escaping ByteItemHandler, didSetAsPrimary: @escaping ByteItemHandler) {
        self.byte = byte
        self.isSelected = isSelected
        self.didSelectByte = didSelectByte
        self.didSetAsPrimary = didSetAsPrimary
        self.highlightedText = highlightedText
        
        super.init(index: index)
        
        self.buildID = byte.buildID
        self.byteID = byte.byteData.byteID
        self.imageUrl = byte.byteData.byteImage.pngUrl
        self.name = "\(byte.byteName.uppercased())"
        self.roles = byte.role != "" ? byte.role : "Bytes"
        self.isPrimary = byte.isPrimary
    }
    
    // MARK: - Actions
    
    func setAsPrimary() {
        if self.isPrimary {
            return
        }
        self.didSetAsPrimary(self.byte)
        self.isPrimary = true
    }
    
    func selectByte() {
        if self.isSelected {
            return
        }
        self.didSelectByte(self.byte)
        self.isSelected = true
    }
}
