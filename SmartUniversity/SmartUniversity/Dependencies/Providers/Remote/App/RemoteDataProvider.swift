//
//  RemoteDataProvider.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 29/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import Foundation

final class RemoteDataProvider: RemoteJSONDataProviding {

    static let shared = RemoteDataProvider()

    let urlSessionProvider: URLSessionProviding

    init(urlSessionProvider: URLSessionProviding = URLSession.shared) {
        self.urlSessionProvider = urlSessionProvider
    }

    func fetchJSONData<JSONData: Decodable>(
        withDataInfo info: RemoteJSONDataInfo,
        completion: @escaping (JSONData?, DataFetchError?) -> Void,
        onQueue queue: DispatchQueue
    ) {
        guard let url = URL(string: info.jsonURLString) else { return completion(nil, .invalidURLString) }

        queue.async {
            self.urlSessionProvider.dataTask(with: url) { data, _, error in
                if error != nil {
                    return completion(nil, .networkError)
                }

                guard let data = data else {
                    return completion(nil, .noData)
                }

                do {
                    let response = try JSONDecoder().decode(JSONData.self, from: data)
                    completion(response, nil)
                } catch {
                    completion(nil, .parsingError)
                }
            }.resume()
        }
    }
}

extension RemoteDataProvider: QRPointsProviding {

    func getAllQRPoints(completion: @escaping ([QRPoint]?, QRPointsProvidingError?) -> Void) {

        fetchJSONData(withDataInfo: SURemoteDataInfo.qrPoints) { (data: QRPointRemoteArray?, error: DataFetchError?) in
            if let error = error { return completion(nil, .fetch(error: error)) }

            completion(data?.points, nil)
        }
    }
}
