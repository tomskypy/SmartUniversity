//
//  RemoteJSONDataInfo.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 30/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import Foundation

enum RemoteJSONDataInfo: CaseIterable {
    case qrPoints

    var jsonURLString: String {
        switch self {
        case .qrPoints: return "https://smart-uni-be.herokuapp.com/get/qrpoints"
        }
    }
}
