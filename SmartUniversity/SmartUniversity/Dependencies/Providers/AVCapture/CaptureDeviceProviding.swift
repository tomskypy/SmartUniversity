//
//  CaptureDeviceProviding.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 18/06/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import AVFoundation

protocol CaptureDeviceProviding {

    var videoCaptureDevice: AVCaptureDevice? { get }
}
