//
//  RemoteDataProviding.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 29/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import Foundation

enum RemoteDataError {
    case invalidURLString
}

protocol RemoteJSONDataProviding {

    func getAllData(withDataInfo info: RemoteJSONDataInfo, completion: @escaping (Decodable?, RemoteDataError?) -> ())
}
