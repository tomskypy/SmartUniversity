//
//  QRPointIDParser.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 21/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import Foundation

struct QRPointIDParser: QRPointIDParsing {

    func parseUUID(from value: String) -> UUID? {
        let matchesOfTextInBrackets = value.matches(regex: "\\((.*?)\\)")
        guard
            matchesOfTextInBrackets.count == 1,
            let uuidStringInBrackets = matchesOfTextInBrackets.first
        else {
            return nil
        }

        let uuidString = uuidStringInBrackets[1..<uuidStringInBrackets.count - 1]
        return UUID(uuidString: uuidString)
    }
}
