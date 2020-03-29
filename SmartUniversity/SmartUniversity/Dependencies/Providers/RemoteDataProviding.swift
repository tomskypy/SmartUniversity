//
//  RemoteDataProviding.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 29/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import Foundation

enum DataFetchError {
    case invalidURLString
    case noData
    case parsingError(error: Error)
}

protocol RemoteJSONDataProviding {

    func fetchJSONData<JSONData: Decodable>(
        withDataInfo info: RemoteJSONDataInfo,
        completion: @escaping (JSONData?, DataFetchError?) -> Void
    )
}
