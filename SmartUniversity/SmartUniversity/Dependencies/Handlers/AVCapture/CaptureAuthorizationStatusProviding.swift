//
//  CaptureAuthorizationStatusProviding.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 06/07/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import AVFoundation

protocol CaptureAuthorizationStatusProviding {

    var videoCaptureAuthorizationStatus: AVAuthorizationStatus { get }
}
