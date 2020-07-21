//
//  QRPoint.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 29/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

struct QRPoint: Decodable {

    let uuidString: String
    let label: String
    let muniMapPlaceID: String

    let rooms: [ARLocalizedObjectData]

    private enum CodingKeys: String, CodingKey {
        case uuidString = "id"
        case label
        case muniMapPlaceID = "munimap"
        case rooms = "arObjects"
    }
}

extension QRPoint: Equatable {

    static func == (lhs: QRPoint, rhs: QRPoint) -> Bool {
        lhs.uuidString == rhs.uuidString
    }
}
