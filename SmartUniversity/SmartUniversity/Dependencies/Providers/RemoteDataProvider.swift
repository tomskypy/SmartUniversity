//
//  RemoteDataProvider.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 29/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import Foundation

final class RemoteDataProvider {

    static let shared = RemoteDataProvider()

    let urlSessionProvider: URLSessionProviding

    init(urlSessionProvider: URLSessionProviding = URLSession.shared) {
        self.urlSessionProvider = urlSessionProvider
    }
}
