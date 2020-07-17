//
//  AppURL.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 18/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import Foundation

enum AppURL {
    case munimap(placeID: String?)

    var value: URL {
        switch self {
        case .munimap(let placeID): return Self.makeMunimapServerURL(withPlaceID: placeID)
        }
    }
}

private extension AppURL {

    private static func makeMunimapServerURL(withPlaceID placeID: String?) -> URL {
        let baseURLString = "https://smart-uni-be.herokuapp.com/munimap?device=mobile"

        let urlString: String
        if let placeID = placeID {
            urlString = "\(baseURLString)&id=\(placeID)"
        } else {
            urlString = baseURLString
        }

        guard let url = URL(string: urlString) else {
            fatalError("Failed to create munimap server url.")
        }

        return url
    }
}
