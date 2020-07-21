//
//  RemoteJSONDataProviding.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 29/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import Foundation

enum DataFetchError: Equatable {
    case invalidURLString
    case noData
    case parsingError
    case networkError
}

protocol RemoteJSONDataProviding {

    func fetchJSONData<JSONData: Decodable>(
        withDataInfo info: RemoteJSONDataInfo,
        completion: @escaping (JSONData?, DataFetchError?) -> Void,
        onQueue queue: DispatchQueue
    )
}

extension RemoteJSONDataProviding {

    func fetchJSONData<JSONData: Decodable>(
        withDataInfo info: RemoteJSONDataInfo,
        completion: @escaping (JSONData?, DataFetchError?) -> Void
    ) {
        fetchJSONData(
            withDataInfo: info,
            completion: completion,
            onQueue: DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
        )
    }
}
