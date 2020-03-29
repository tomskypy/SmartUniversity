//
//  URLSessionProviding.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 29/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import Foundation

protocol URLSessionProviding {

    func dataTask(
        with url: URL,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

extension URLSession: URLSessionProviding { }
