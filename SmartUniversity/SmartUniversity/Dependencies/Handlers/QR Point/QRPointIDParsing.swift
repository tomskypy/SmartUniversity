//
//  QRPointIDParsing.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 21/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import Foundation

protocol QRPointIDParsing {

    func parseUUID(from value: String) -> UUID?
}
