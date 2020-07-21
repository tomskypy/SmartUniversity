//
//  QRPointRemoteArray.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 18/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

enum QRPointsProvidingError {
    case fetch(error: DataFetchError)
}

struct QRPointRemoteArray: Decodable {
    let points: [QRPoint]

    private enum CodingKeys: String, CodingKey {
        case points = "qrPoints"
    }
}
