//
//  QRPoint.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 29/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import Foundation

struct QRPoint: Decodable {

    let uuidString: String
    let label: String
    let muniMapPlaceID: String

    let rooms: [ARLocalizedObject]

    private enum CodingKeys: String, CodingKey {
        case uuidString = "id"
        case label
        case muniMapPlaceID = "munimap"
        case rooms = "arObjects"
    }
}
