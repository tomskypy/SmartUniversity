//
//  String+RegexMatches.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 21/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import Foundation

extension String {

    func matches(regex: String) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: [.caseInsensitive]) else { return [] }

        let matches = regex.matches(in: self, options: [], range: NSMakeRange(0, self.count))

        return matches.compactMap { match in
            guard let substringRange = Range(match.range, in: self) else { return nil }
            return String(self[substringRange])
        }
    }
}
