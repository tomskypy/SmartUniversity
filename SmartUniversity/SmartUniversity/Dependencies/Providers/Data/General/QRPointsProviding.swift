//
//  QRPointsProviding.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 30/03/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

protocol QRPointsProviding {

    func getAllQRPoints(completion: @escaping ([QRPoint]?, QRPointsProvidingError?) -> Void)
}
