//
//  Collection+SafeIndex.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 16/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

extension Collection {

    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
