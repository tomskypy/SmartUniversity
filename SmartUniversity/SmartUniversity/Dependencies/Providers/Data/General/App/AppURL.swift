//
//  AppURL.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 18/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import Foundation

enum AppURL {
    case munimap(placeID: String)

    var value: URL {
        switch self {
        case .munimap(let placeID): return Self.makeMunimapServerURL(withPlaceID: placeID)
        }
    }
}

private extension AppURL {

    private static func makeMunimapServerURL(withPlaceID placeID: String) -> URL {
        guard let url = URL(string: "https://smart-uni-be.herokuapp.com/munimap?device=mobile&id=\(placeID)") else {
            fatalError("Failed to create munimap server url.")
        }
        return url
    }
}
