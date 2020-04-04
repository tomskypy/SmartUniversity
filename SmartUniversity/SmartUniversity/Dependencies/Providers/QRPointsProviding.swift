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

struct QRPointRemoteArray: Decodable {
    let points: [QRPoint]

    private enum CodingKeys: String, CodingKey {
        case points = "qrPoints"
    }
}

protocol QRPointsProviding: RemoteJSONDataProviding {

    func getAllQRPoints(completion: @escaping ([QRPoint]?, QRPointsProvidingError?) -> Void)
}

extension QRPointsProviding {

    func getAllQRPoints(completion: @escaping ([QRPoint]?, QRPointsProvidingError?) -> Void) {

        fetchJSONData(withDataInfo: SURemoteDataInfo.qrPoints) { (data: QRPointRemoteArray?, error: DataFetchError?) in
            if let error = error { return completion(data?.points, .fetch(error: error)) }

            completion(data?.points, nil)
        }
    }
}
