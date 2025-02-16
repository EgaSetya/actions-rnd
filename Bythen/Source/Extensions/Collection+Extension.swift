//
//  Collection+Extension.swift
//  Bythen
//
//  Created by Darindra R on 28/10/24.
//

import Foundation

public extension Collection {
    /// This is for better readibilty instead of using `!`
    var isNotEmpty: Bool {
        return !isEmpty
    }

    /// Safe subscript that provides a way to access elements from a collection without risking index
    /// out-of-bounds errors.
    subscript(safe index: Index) -> Element? {
        /// Check if the given index is within the valid range of indices for the collection.
        /// If the index is valid, return the corresponding element; otherwise, return nil.
        return indices.contains(index) ? self[index] : nil
    }
}
