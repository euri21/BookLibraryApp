//
//  Collection+Extension.swift
//  BookLibraryApp
//
//  Created by solution888 on 5/13/22.
//

import Foundation

extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
