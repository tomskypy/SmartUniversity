//
//  QRPointsProviding.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 30/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

enum QRPointsProvidingError {
    case fetch(error: DataFetchError)
}

protocol QRPointsProviding: RemoteJSONDataProviding {

    func getAllQRPoints(completion: @escaping ([QRPoint]?, QRPointsProvidingError?) -> ())
}

extension QRPointsProviding {

    func getAllQRPoints(completion: @escaping ([QRPoint]?, QRPointsProvidingError?) -> ()) {
        
        fetchJSONData(withDataInfo: .qrPoints) { (data: [QRPoint]?, error: DataFetchError?) in
            if let error = error { return completion(data, .fetch(error: error)) }

            completion(data, nil)
        }
    }
}
