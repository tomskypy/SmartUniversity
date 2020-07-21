//
//  String+Subscript.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 21/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import Foundation

extension String {

    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])
    }
}
