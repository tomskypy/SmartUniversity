//
//  CaptureAuthorizationRequesting.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 19/07/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import Foundation

protocol CaptureAuthorizationRequesting {

    func requestAccessForVideo(completion: @escaping (Bool) -> Void)
}
