//
//  RemoteJSONDataInfo.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 30/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

protocol RemoteJSONDataInfo {

    var jsonURLString: String { get }
}

enum SURemoteDataInfo: CaseIterable, RemoteJSONDataInfo {
    case qrPoints
    case faculties

    var jsonURLString: String {
        let queryString: String
        switch self {
            case .qrPoints:     queryString = "get/qrpoints"
            case .faculties:    queryString = "get/faculties"
        }
        return Self.baseURLString + queryString
    }

    private static let baseURLString = "https://smart-uni-be.herokuapp.com/"
}
