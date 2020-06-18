//
//  AppURL.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 18/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import Foundation

enum AppURL {
    case munimap

    var value: URL {
        switch self {
        case .munimap: return Self.munimapServerURL
        }
    }
}

private extension AppURL {

    private static var munimapServerURL: URL = {
        guard let url = URL(string: "https://smart-uni-be.herokuapp.com/munimap?device=mobile") else {
            fatalError("Failed to create munimap server url.")
        }
        return url
    }()
}
